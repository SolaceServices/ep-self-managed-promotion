terraform {
required_providers {
solacebroker = {
source = "registry.terraform.io/solaceproducts/solacebroker"
}
}
}

provider "solacebroker" {
alias = "id_fgnr93258z2"
username = "${var.username}"
password = "${var.password}"
url = "${var.url}"
skip_api_check = true
insecure_skip_verify = false
}

data "solacebroker_msg_vpn" "id_fgnr93258z2" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = "sandbox"
}


variable username {
}

variable password {
}

variable url {
}
