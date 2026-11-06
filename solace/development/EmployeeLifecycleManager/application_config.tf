terraform {
required_providers {
solacebroker = {
source = "registry.terraform.io/solaceproducts/solacebroker"
}
}
}

provider "solacebroker" {
alias = "id_9on7jb3s886"
username = "${var.username}"
password = "${var.password}"
url = "${var.url}"
skip_api_check = true
insecure_skip_verify = false
}

data "solacebroker_msg_vpn" "id_9on7jb3s886" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = "sandbox"
}


variable username {
}

variable password {
}

variable url {
}
