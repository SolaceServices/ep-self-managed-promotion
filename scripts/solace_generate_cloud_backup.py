#!/usr/bin/env python3
"""Generate Terraform files (solacecloud provider) from existing Solace Cloud services.

Reads the services of the account through the Mission Control API and writes:
  - provider.tf               : terraform / provider configuration (+ environment data source when --public)
  - solacecloud_service.<service-name>.tf : one file per service with the resource and an import block

The API token is passed with --token, or read from the SOLACECLOUD_API_TOKEN environment variable
when the argument is omitted. It is never written to the generated files; when running terraform,
provide it through the SOLACECLOUD_API_TOKEN environment variable.
"""
import argparse
import os
import re
import sys
from pathlib import Path

import requests

API_BASE = "https://api.solace.cloud"
SERVICES_PATH = "/api/v2/missionControl/eventBrokerServices"
PAGE_SIZE = 100
TIMEOUT = 60

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_OUTPUT = REPO_ROOT / "solace" / "cloud"


def parse_args():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--token", default=os.environ.get("SOLACECLOUD_API_TOKEN"),
                   help="Solace Cloud API token used to query the account. "
                        "Falls back to the SOLACECLOUD_API_TOKEN environment variable.")
    p.add_argument("--public", action="store_true",
                   help="Brokers are in a public region: add a solacecloud_environment data source "
                        "and set environment_id on each service. Omitted entirely otherwise.")
    p.add_argument("--services", default="",
                   help="Comma separated list of service names to export. Empty = all services.")
    p.add_argument("--environment-name", default="Default",
                   help="Environment name used by the data source when --public is set (default: Default).")
    p.add_argument("--base-url", default=API_BASE,
                   help=f"Solace Cloud API base URL (default: {API_BASE}).")
    p.add_argument("--output-dir", default=str(DEFAULT_OUTPUT),
                   help=f"Output folder (default: {DEFAULT_OUTPUT}).")
    return p.parse_args()


def api_get(session, base_url, path, params=None):
    resp = session.get(f"{base_url.rstrip('/')}{path}", params=params, timeout=TIMEOUT)
    resp.raise_for_status()
    return resp.json()


def list_services(session, base_url):
    services, page = [], 1
    while True:
        body = api_get(session, base_url, SERVICES_PATH, {"pageNumber": page, "pageSize": PAGE_SIZE})
        data = body.get("data", [])
        services.extend(data)
        if len(data) < PAGE_SIZE:
            return services
        page += 1


def hcl_str(value):
    """Quote a value as an HCL string."""
    s = str(value).replace("\\", "\\\\").replace('"', '\\"').replace("${", "$${").replace("%{", "%%{")
    return f'"{s}"'


def tf_label(name):
    label = re.sub(r"[^A-Za-z0-9_-]", "_", name)
    if not re.match(r"[A-Za-z_]", label):
        label = f"_{label}"
    return label


def file_name(name):
    return f"solacecloud_service.{re.sub(r'[^A-Za-z0-9._-]', '_', name)}.tf"


def provider_tf(base_url, public, env_name):
    out = f"""terraform {{
  required_providers {{
    solacecloud = {{
      source = "solaceproducts/solacecloud"
    }}
  }}
}}

# The API token is read from the SOLACECLOUD_API_TOKEN environment variable.
provider "solacecloud" {{
  base_url = {hcl_str(base_url.rstrip('/') + '/')}
}}
"""
    if public:
        out += f"""
data "solacecloud_environment" "environment" {{
  name = {hcl_str(env_name)}
}}
"""
    return out


def service_tf(svc, label, public):
    lines = [f'resource "solacecloud_service" "{label}" {{',
             f'  name             = {hcl_str(svc["name"])}',
             f'  datacenter_id    = {hcl_str(svc["datacenterId"])}']
    if svc.get("serviceClassId"):
        lines.append(f'  service_class_id = {hcl_str(svc["serviceClassId"])}')
    if svc.get("eventBrokerServiceVersion"):
        lines.append(f'  event_broker_version = {hcl_str(svc["eventBrokerServiceVersion"])}')
    if svc.get("msgVpnName"):
        lines.append(f'  message_vpn_name = {hcl_str(svc["msgVpnName"])}')
    if public:
        lines.append('  environment_id   = data.solacecloud_environment.environment.id')
    lines.append("}")
    lines.append("")
    lines.append("import {")
    lines.append(f"  to = solacecloud_service.{label}")
    lines.append(f"  id = {hcl_str(svc['id'])}")
    lines.append("}")
    return "\n".join(lines) + "\n"


def main():
    args = parse_args()
    token = args.token
    if not token:
        sys.exit("ERROR: provide the API token with --token or the SOLACECLOUD_API_TOKEN environment variable.")

    wanted = [n.strip() for n in args.services.split(",") if n.strip()]

    session = requests.Session()
    session.headers.update({"Authorization": f"Bearer {token}", "Accept": "application/json"})

    try:
        services = list_services(session, args.base_url)
        by_name = {}
        for s in services:
            by_name.setdefault(s["name"], []).append(s)

        if wanted:
            selected = []
            for name in wanted:
                if name not in by_name:
                    print(f"WARNING: service '{name}' not found in the account, skipping.", file=sys.stderr)
                else:
                    selected.extend(by_name[name])
        else:
            selected = services

        if not selected:
            sys.exit("No services to export.")

        out_dir = Path(args.output_dir)
        out_dir.mkdir(parents=True, exist_ok=True)
        (out_dir / "provider.tf").write_text(provider_tf(args.base_url, args.public, args.environment_name),
                                             encoding="utf-8", newline="\n")
        print(f"Wrote {out_dir / 'provider.tf'}")

        used_labels = set()
        for summary in selected:
            detail = api_get(session, args.base_url, f"{SERVICES_PATH}/{summary['id']}")["data"]
            label = tf_label(detail["name"])
            if label in used_labels:  # duplicate service names: disambiguate with the id
                label = f"{label}_{tf_label(detail['id'])}"
            used_labels.add(label)
            path = out_dir / file_name(label)
            path.write_text(service_tf(detail, label, args.public), encoding="utf-8", newline="\n")
            print(f"Wrote {path}")
    except requests.HTTPError as e:
        sys.exit(f"ERROR: API call failed: {e.response.status_code} {e.response.text[:300]}")
    except requests.RequestException as e:
        sys.exit(f"ERROR: {e}")


if __name__ == "__main__":
    main()
