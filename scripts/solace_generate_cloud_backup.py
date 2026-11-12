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
V0_SERVICES_PATH = "/api/v0/services"

# v0 connection endpoint port name -> `ports` key of the terraform connection_endpoint block.
# Ports set to 0 (disabled) are skipped. Management (943) and SSH (2222) ports are not
# user-configurable messaging ports, so they are intentionally not exported.
V0_PORT_KEYS = {
    "serviceSmfPlainTextListenPort": "smf",
    "serviceSmfTlsListenPort": "smf_tls",
    "serviceSmfCompressedListenPort": "smf_compressed",
    "serviceMqttPlainTextListenPort": "mqtt",
    "serviceMqttTlsListenPort": "mqtt_tls",
    "serviceMqttWebSocketListenPort": "mqtt_websocket",
    "serviceMqttTlsWebSocketListenPort": "mqtt_websocket_tls",
    "serviceAmqpPlainTextListenPort": "amqp",
    "serviceAmqpTlsListenPort": "amqp_tls",
    "serviceRestIncomingPlainTextListenPort": "rest_incoming",
    "serviceRestIncomingTlsListenPort": "rest_incoming_tls",
    "serviceWebPlainTextListenPort": "web",
    "serviceWebTlsListenPort": "web_tls",
}
PAGE_SIZE = 100
TIMEOUT = 60

DEFAULT_REPO_ROOT = Path(__file__).resolve().parent.parent
OUTPUT_SUBDIR = Path("solace") / "cloud"


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
    p.add_argument("--repo-root", default=str(DEFAULT_REPO_ROOT),
                   help=f"Repository root; files are written to <repo-root>/{OUTPUT_SUBDIR.as_posix()} "
                        f"(default: {DEFAULT_REPO_ROOT}).")
    p.add_argument("--output-dir", default=None,
                   help="Explicit output folder. Overrides --repo-root when given.")
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


def fetch_v0_service(session, base_url, service_id):
    """Legacy v0 service details (spool size, DMR cluster, mate link encryption, endpoints...).
    Returns {} and warns when unavailable so the base attributes are still generated."""
    try:
        return api_get(session, base_url, f"{V0_SERVICES_PATH}/{service_id}").get("data", {})
    except requests.RequestException as e:
        print(f"WARNING: could not read v0 details of service {service_id} ({e}); "
              "optional attributes will be omitted.", file=sys.stderr)
        return {}


def hcl_value(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    return hcl_str(value)


def hcl_attrs(pairs, indent):
    """Render (key, value) pairs as aligned `key = value` lines (value None = raw expression already set)."""
    width = max(len(k) for k, _ in pairs)
    return [f"{indent}{k.ljust(width)} = {v}" for k, v in pairs]


def optional_attributes(v0, svc):
    """Map the v0 response to optional solacecloud_service arguments, as (key, hcl_value) pairs."""
    pairs = []
    spool = v0.get("messagingStorage")  # GB
    if isinstance(spool, int) and 10 <= spool <= 6000:
        pairs.append(("max_spool_usage", hcl_value(spool)))
    if isinstance(v0.get("locked"), bool):
        pairs.append(("locked", hcl_value(v0["locked"])))
    owner = svc.get("ownedBy") or v0.get("userId")
    if owner:
        pairs.append(("owned_by", hcl_value(owner)))
    if v0:
        cluster = v0.get("cluster")
        pairs.append(("dmr_enabled", hcl_value(bool(cluster))))
        if cluster and cluster.get("name"):
            pairs.append(("cluster_name", hcl_value(cluster["name"])))
    # mate link encryption is only accepted by HA services
    if str(svc.get("serviceClassId", "")).endswith("_HIGHAVAILABILITY") \
            and isinstance(v0.get("redundancyGroupSslEnabled"), bool):
        pairs.append(("mate_link_encryption", hcl_value(v0["redundancyGroupSslEnabled"])))
    return pairs


def connection_endpoint_block(v0):
    endpoints = v0.get("serviceConnectionEndpoints") or []
    if not endpoints:
        return []
    ep = endpoints[0]
    access = str(ep.get("accessType", "")).upper()
    if not ep.get("name") or access not in ("PUBLIC", "PRIVATE"):
        return []
    pairs = [("name", hcl_str(ep["name"]))]
    if ep.get("description"):
        pairs.append(("description", hcl_str(ep["description"])))
    pairs.append(("access_type", hcl_str(access)))
    lines = ["", "  connection_endpoint {", *hcl_attrs(pairs, "    ")]
    ports = [(key, ep["ports"][v0_name]) for v0_name, key in V0_PORT_KEYS.items()
             if isinstance((ep.get("ports") or {}).get(v0_name), int) and ep["ports"][v0_name] > 0]
    if ports:
        lines.append("")
        lines.append("    ports = {")
        for key, port in ports:
            lines += [f"      {key} = {{", f"        port = {port}", "      }"]
        lines.append("    }")
    lines.append("  }")
    return lines


def service_tf(svc, v0, label, public):
    pairs = [("name", hcl_str(svc["name"])), ("datacenter_id", hcl_str(svc["datacenterId"]))]
    if svc.get("serviceClassId"):
        pairs.append(("service_class_id", hcl_str(svc["serviceClassId"])))
    if svc.get("eventBrokerServiceVersion"):
        pairs.append(("event_broker_version", hcl_str(svc["eventBrokerServiceVersion"])))
    if svc.get("msgVpnName"):
        pairs.append(("message_vpn_name", hcl_str(svc["msgVpnName"])))
    pairs.extend(optional_attributes(v0, svc))
    if public:
        pairs.append(("environment_id", "data.solacecloud_environment.environment.id"))
    lines = [f'resource "solacecloud_service" "{label}" {{',
             *hcl_attrs(pairs, "  "),
             *connection_endpoint_block(v0)]
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

        out_dir = Path(args.output_dir) if args.output_dir else Path(args.repo_root).resolve() / OUTPUT_SUBDIR
        out_dir.mkdir(parents=True, exist_ok=True)
        provider_path = out_dir / "provider.tf"
        if provider_path.exists():
            print(f"Skipping {provider_path}: file already exists, not overwriting.")
        else:
            provider_path.write_text(provider_tf(args.base_url, args.public, args.environment_name),
                                     encoding="utf-8", newline="\n")
            print(f"Wrote {provider_path}")

        used_labels = set()
        for summary in selected:
            detail = api_get(session, args.base_url, f"{SERVICES_PATH}/{summary['id']}")["data"]
            label = tf_label(detail["name"])
            if label in used_labels:  # duplicate service names: disambiguate with the id
                label = f"{label}_{tf_label(detail['id'])}"
            used_labels.add(label)
            path = out_dir / file_name(label)
            path.write_text(service_tf(detail, fetch_v0_service(session, args.base_url, detail["id"]), label, args.public), encoding="utf-8", newline="\n")
            print(f"Wrote {path}")
    except requests.HTTPError as e:
        sys.exit(f"ERROR: API call failed: {e.response.status_code} {e.response.text[:300]}")
    except requests.RequestException as e:
        sys.exit(f"ERROR: {e}")


if __name__ == "__main__":
    main()
