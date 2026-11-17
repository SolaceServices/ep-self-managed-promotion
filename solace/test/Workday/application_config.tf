terraform {
required_providers {
solacebroker = {
source = "registry.terraform.io/solaceproducts/solacebroker"
}
}
}

provider "solacebroker" {
alias = "id_h50s5r5w34l"
username = "${var.username}"
password = "${var.password}"
url = "${var.url}"
skip_api_check = true
insecure_skip_verify = false
}

data "solacebroker_msg_vpn" "id_h50s5r5w34l" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = "sandbox"
}


variable username {
}

variable password {
}

variable url {
}
