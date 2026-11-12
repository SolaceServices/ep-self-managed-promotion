# scripts

Python scripts used by the GitHub Actions workflows (and runnable locally).

| File | Purpose | Used by |
|------|---------|---------|
| `solace_generate_cloud_backup.py` | Reads Solace Cloud services through the REST APIs and generates Terraform files (resources + `import` blocks) | `backup_cloud.yaml` |
| `solace_batch_cli_execution.py` | Connects to a broker over SSH, runs `show current-config`, writes the cleaned CLI configuration to disk | `backup_broker.yaml`, `backup_message_vpn.yaml` |
| `requirements.txt` | Pinned Python dependencies | all of the above |
| `mission-control.json` | OpenAPI specification of the Solace Cloud **Mission Control** API (v2.6.0). Reference material only, no script reads it | developers |

Contents

- [Installation](#installation)
- [solace_generate_cloud_backup.py](#solace_generate_cloud_backuppy)
- [solace_batch_cli_execution.py](#solace_batch_cli_executionpy)
- [Using the scripts from GitHub Actions](#using-the-scripts-from-github-actions)

---

## Installation

Requires Python 3 (CI uses 3.12).

```bash
cd scripts
python -m venv .venv
source .venv/bin/activate           # Windows PowerShell: .venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

`requirements.txt`:

```
bcrypt==5.0.0
cffi==2.1.1
cryptography==50.0.2
invoke==3.0.3
paramiko==5.1.0
pycparser==3.12
PyNaCl==1.6.2
requests==2.32.3
```

- `requests` is used by `solace_generate_cloud_backup.py`.
- `paramiko` (and its dependencies `bcrypt`, `cffi`, `cryptography`, `pycparser`, `PyNaCl`) is used by
  `solace_batch_cli_execution.py`.

---

## solace_generate_cloud_backup.py

Generates Terraform for the `solaceproducts/solacecloud` provider from the services that currently exist in a
Solace Cloud account. Each service becomes its own file containing the service, its connection endpoints, the
custom DNS names, and `import` blocks so Terraform adopts the existing objects instead of creating new ones.

### Usage

```bash
python solace_generate_cloud_backup.py [--token TOKEN] [--public] [--services NAMES]
                                       [--base-url URL] [--repo-root DIR] [--output-dir DIR]
```

| Argument | Default | Description |
|----------|---------|-------------|
| `--token` | env `SOLACECLOUD_API_TOKEN` | Solace Cloud API token. If neither the argument nor the variable is set the script exits with an error. |
| `--public` | off | Services are in a **public region**. For each service the script looks up its environment and writes `environment_id`. Without the flag `environment_id` is never written. |
| `--services` | empty | Comma-separated list of **service names** to export, for example `--services="svc-a,svc-b"`. Empty exports every service in the account. A name that is not found produces a warning and the script continues. |
| `--base-url` | `https://api.solace.cloud` | API base URL. Change it if your account's home cloud region uses a different URL. The same value is written to `provider.tf`. |
| `--repo-root` | parent folder of `scripts/` | Repository root. Files are written to `<repo-root>/solace/cloud`. |
| `--output-dir` | none | Explicit output folder. Overrides `--repo-root`. |

Examples:

```bash
# Linux / macOS / Git Bash: export everything, services in a dedicated region
export SOLACECLOUD_API_TOKEN=<token>
python solace_generate_cloud_backup.py

# Only two services, public region, explicit repo root
python solace_generate_cloud_backup.py --public --services="ajcr-sandbox-primary,ajcr-sandbox-backup" --repo-root=..

# Windows PowerShell
$env:SOLACECLOUD_API_TOKEN = "<token>"
python solace_generate_cloud_backup.py --public --repo-root D:\checkouts\ep-self-managed-promotion
```

Prefer the environment variable over `--token`: a token on the command line can appear in shell history and process
listings. The token is only used to call the APIs and is **never written to the generated files**.

### What it calls

| Purpose | Call |
|---------|------|
| List services (paged, 100 per page) | `GET /api/v2/missionControl/eventBrokerServices?pageNumber=N&pageSize=100` |
| Service details | `GET /api/v2/missionControl/eventBrokerServices/{id}` |
| Extra service details | `GET /api/v0/services/{id}` |
| Environment (only with `--public`) | `GET /api/v2/missionControl/environments/{id}` |

All calls send `Authorization: Bearer <token>`, have a 60 second timeout and are made through one `requests`
session. If the v0 call fails for a service the script warns and writes only the attributes available from v2 for
that service.

### Output

Files are written to `<repo-root>/solace/cloud/`:

| File | Content | Overwritten? |
|------|---------|--------------|
| `provider.tf` | `required_providers` block for `solaceproducts/solacecloud` and the provider block with `base_url` | **Never.** If the file exists it is left untouched and a message is printed. |
| `solacecloud_service.<service-name>.tf` | The service, its connection endpoints, DNS names and import blocks | Yes, on every run. |

The file name is `solacecloud_service.` + the service name with any character other than letters, digits, `.`,
`_` and `-` replaced by `_`. This makes it easy to loop over the files later, for example
`solace/cloud/solacecloud_service.*.tf`. If two services have the same name the second file gets the service id
appended.

Files from earlier runs that no longer match a current service name (for example after a rename) are **not**
removed. Delete them manually, otherwise Terraform sees duplicate resources.

#### `provider.tf`

```hcl
terraform {
  required_providers {
    solacecloud = {
      source = "solaceproducts/solacecloud"
    }
  }
}

# The API token is read from the SOLACECLOUD_API_TOKEN environment variable.
provider "solacecloud" {
  base_url = "https://api.solace.cloud/"
}
```

The provider reads its token from `SOLACECLOUD_API_TOKEN` when Terraform runs.

#### Service file

```hcl
data "solacecloud_environment" "my-service_environment" {   # only with --public and a resolvable name
  name = "Default"
}

resource "solacecloud_service" "my-service" {
  name                 = "my-service"
  datacenter_id        = "eks-us-east-1a"
  service_class_id     = "ENTERPRISE_1K_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9219-22"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = false
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = false
  mate_link_encryption = true
  environment_id       = data.solacecloud_environment.my-service_environment.id
}

import {
  to = solacecloud_service.my-service
  id = "<service id>"
}

resource "solacecloud_connection_endpoint" "my-service_Public_Endpoint" {
  service_id  = solacecloud_service.my-service.id
  access_type = "PUBLIC"
  name        = "Public Endpoint"

  ports = {
    management_tls = {
      port = 943
    }
    smf_tls = {
      port = 55443
    }
  }
}

import {
  to = solacecloud_connection_endpoint.my-service_Public_Endpoint
  id = "<service id>/connectionEndpoints/<endpoint id>"
}

resource "solacecloud_connection_endpoint_dns_name" "my-service_Public_Endpoint_dns_my-service_messaging_solace_cloud" {
  service_id             = solacecloud_service.my-service.id
  connection_endpoint_id = solacecloud_connection_endpoint.my-service_Public_Endpoint.id
  dns_name               = "my-service.messaging.solace.cloud"
}

import {
  to = solacecloud_connection_endpoint_dns_name.my-service_Public_Endpoint_dns_my-service_messaging_solace_cloud
  id = "<service id>/<endpoint id>/my-service.messaging.solace.cloud"
}
```

Resource labels are derived from the names (characters other than letters, digits, `_` and `-` become `_`).

### Attribute mapping

`solacecloud_service`:

| Terraform argument | Source | Rule |
|--------------------|--------|------|
| `name` | v2 `name` | always |
| `datacenter_id` | v2 `datacenterId` | always |
| `service_class_id` | v2 `serviceClassId` | when present (for example `ENTERPRISE_1K_HIGHAVAILABILITY`) |
| `event_broker_version` | v2 `eventBrokerServiceVersion` | when present |
| `message_vpn_name` | v2 `msgVpnName` | when present |
| `max_spool_usage` | v0 `messagingStorage` (GB) | only when between 10 and 6000 (provider limits) |
| `locked` | v0 `locked` | when it is a boolean |
| `owned_by` | v2 `ownedBy`, falling back to v0 `userId` | when present |
| `dmr_enabled` | v0 `cluster` | `true` when a cluster object exists, `false` otherwise; only written when the v0 call succeeded |
| `cluster_name` | v0 `cluster.name` | only when DMR is enabled |
| `mate_link_encryption` | v0 `redundancyGroupSslEnabled` | only for `*_HIGHAVAILABILITY` classes (the provider refuses it on standalone services) |
| `environment_id` | v2 `environmentId` | only with `--public`; see below |

`environment_id` with `--public` is resolved per service, in this order:

1. The environments API returns a `name`: a `data "solacecloud_environment"` block is written in the service file
   and referenced (`data.solacecloud_environment.<service>_environment.id`).
2. The call fails or returns no name: the literal environment id from the v2 response is written and a warning is
   printed. The documented response of `GET /environments/{id}` does not include a name, so this fallback is
   expected in practice. A literal id only works in the same Solace Cloud account.
3. The service has no `environmentId`: `environment_id` is omitted and a warning is printed.

Each environment is looked up once per run.

`solacecloud_connection_endpoint` (one per entry of v0 `serviceConnectionEndpoints`):

| Terraform argument | Source |
|--------------------|--------|
| `service_id` | reference to the service resource |
| `access_type` | v0 `accessType` upper-cased (`PUBLIC` / `PRIVATE`) |
| `name` | v0 `name` |
| `description` | v0 `description`, only when not empty |
| `ports` | v0 `ports`, see below |

An endpoint without a name, an id or a valid access type is skipped with a warning.

Port mapping (ports set to `0` are disabled in Solace Cloud and are omitted; if none remain `ports = {}` is written):

| v0 port name | `ports` key |
|--------------|-------------|
| `serviceManagementTlsListenPort` | `management_tls` |
| `managementSshTlsListenPort` | `ssh_tls` |
| `serviceSmfPlainTextListenPort` | `smf` |
| `serviceSmfTlsListenPort` | `smf_tls` |
| `serviceSmfCompressedListenPort` | `smf_compressed` |
| `serviceMqttPlainTextListenPort` | `mqtt` |
| `serviceMqttTlsListenPort` | `mqtt_tls` |
| `serviceMqttWebSocketListenPort` | `mqtt_websocket` |
| `serviceMqttTlsWebSocketListenPort` | `mqtt_websocket_tls` |
| `serviceAmqpPlainTextListenPort` | `amqp` |
| `serviceAmqpTlsListenPort` | `amqp_tls` |
| `serviceRestIncomingPlainTextListenPort` | `rest_incoming` |
| `serviceRestIncomingTlsListenPort` | `rest_incoming_tls` |
| `serviceWebPlainTextListenPort` | `web` |
| `serviceWebTlsListenPort` | `web_tls` |

`solacecloud_connection_endpoint_dns_name` (one per custom hostname of an endpoint): the Solace-generated default
hostname (`mr-connection-<endpoint id>.*`) is skipped because it cannot be managed or deleted. The provider allows
at most 5 DNS names per endpoint and requires domains outside `messaging.solace.cloud` to be owned by you; the
script does not check either.

Import ids:

| Resource | Import id |
|----------|-----------|
| `solacecloud_service` | `<service id>` |
| `solacecloud_connection_endpoint` | `<service id>/connectionEndpoints/<endpoint id>` |
| `solacecloud_connection_endpoint_dns_name` | `<service id>/<endpoint id>/<dns name>` |

Import blocks require Terraform 1.5 or newer.

### Not exported

Anything the provider resource does not take as an argument, and the optional extras not yet mapped: client
profiles, certificate authorities, monitoring settings, accounting limits, passwords and tokens. No credentials from
the API responses are written to the files.

### Exit behaviour

| Situation | Result |
|-----------|--------|
| No token | exit with an error message |
| No service matches (or the account has none) | exit with `No services to export.` |
| HTTP error from the list or service calls | exit with the status code and the first 300 characters of the response |
| Network error | exit with the error |
| Requested name not found | warning on stderr, continues |
| v0 or environment call fails | warning on stderr, continues without those attributes |

### Running Terraform on the output

```bash
cd solace/cloud
export SOLACECLOUD_API_TOKEN=<token>
terraform init \
  -backend-config="bucket=<bucket>" \
  -backend-config="key=solace/cloud/terraform.tfstate" \
  -backend-config="region=<region>"
terraform plan -out=tfplan
terraform apply tfplan
```

The first apply only imports the existing objects into state. The `backup_cloud.yaml` workflow does exactly this.

---

## solace_batch_cli_execution.py

Takes a configuration backup of an event broker (or a single Message VPN) by running the Solace CLI over an
interactive SSH session.

### Usage

```bash
python solace_batch_cli_execution.py -H <hostname> -P <port> -u <username> -x <password> -v <vpn>
```

| Argument | Long form | Required | Description |
|----------|-----------|----------|-------------|
| `-H` | `--hostname` | yes | Broker hostname |
| `-P` | `--port` | yes | SSH port |
| `-u` | `--username` | yes | CLI user. Use a **read-only** user. |
| `-x` | `--password` | yes | Password of that user |
| `-v` | `--vpn_name` | yes | Message VPN name, or `*` for the whole broker |

The command that is run on the broker:

| `-v` value | CLI command |
|------------|-------------|
| `*` | `show current-config all redact` |
| `<name>` | `show current-config message-vpn <name> redact` |

`redact` makes the broker mask secrets such as passwords in the output.

### What it does

1. Opens an SSH connection with `paramiko` (unknown host keys are accepted automatically) and starts an
   interactive shell.
2. Sends `no paging`, `session timeout 0`, the `show current-config` command and a deliberately invalid sentinel
   command (`-----EXIT-----`). When the broker answers that the sentinel is unknown, the script knows the real
   output is complete.
3. Polls the channel every 3 seconds for output, up to 180 seconds, then sends `logout`. A few more polling
   cycles collect any remaining output.
4. Removes the sentinel error text and keeps only the lines between `! BEGIN` and `! END`.
5. Writes the result to the **current directory**:

| File | Content |
|------|---------|
| `output.cli` | The cleaned CLI configuration |
| `output.err.cli` | Anything received on stderr (normally empty) |

### Exit codes

| Code | Meaning |
|------|---------|
| `0` | Finished without an error flag |
| `1` | Authentication failed, SSH error, any unexpected exception during the session, or the broker output contained `ERROR: script` |

The script does not validate the files itself. The workflows check afterwards that `output.cli` exists and is not
empty and that `output.err.cli` is empty, and fail otherwise.

### Notes

- The password is passed as a command-line argument, which can be visible in process listings on shared machines.
- Output is verbose by design (byte counts and wait cycles are printed) to help diagnose slow brokers.
- Both output files are overwritten on every run, so run the script from a clean working folder.

---

## Using the scripts from GitHub Actions

`backup_cloud.yaml`:

```yaml
env:
  SOLACECLOUD_API_TOKEN: ${{ secrets.SOLACE_CLOUD_API_TOKEN }}
  SOLACE_CLOUD_SERVICES: ${{ vars.SOLACE_CLOUD_SERVICES }}              # comma separated names, or empty
  SOLACE_CLOUD_IS_PUBLIC_FLAG: ${{ vars.SOLACE_CLOUD_IS_PUBLIC_FLAG }}  # "--public" or empty
...
working-directory: ./scripts
run: python solace_generate_cloud_backup.py --services="$SOLACE_CLOUD_SERVICES" --repo-root=./../ $SOLACE_CLOUD_IS_PUBLIC_FLAG
```

The flag variable is expanded unquoted, so setting it to `--public` passes the flag and leaving it empty passes
nothing.

`backup_broker.yaml` / `backup_message_vpn.yaml`:

```yaml
working-directory: ./scripts
run: python solace_batch_cli_execution.py -H $BACKUP_SOLACE_BROKER_HOSTNAME -P $BACKUP_SOLACE_BROKER_PORT \
       -u $BACKUP_SOLACE_BROKER_USERNAME -x $BACKUP_SOLACE_BROKER_PASSWORD -v "$MSG_VPN"
```

`MSG_VPN` is `*` for the whole-broker backup and the matrix value (for example `sandbox`) for the per-VPN backup.
