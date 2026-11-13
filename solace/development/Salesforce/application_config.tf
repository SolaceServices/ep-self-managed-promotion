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

data "solacebroker_msg_vpn_client_profile" "clientProfileName_0fee66d20ca52312eafb2515004ab09695825d61c335761c4fe27c5640a03455" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_ae4e50c28154fde53a2c44c967f8f3bfde73c5852968ba538851da39225fe8ad" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_0fee66d20ca52312eafb2515004ab09695825d61c335761c4fe27c5640a03455.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2981a6189a45a23557ce594478edfbc125fd4d4ce5c76f9534b62a00da81c40d.acl_profile_name
client_username = "${var.client_username_8851da39225fe8ad}"
password = "${var.client_password_8851da39225fe8ad}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_2981a6189a45a23557ce594478edfbc125fd4d4ce5c76f9534b62a00da81c40d" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
acl_profile_name = "salesforce_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_422af1ea454e4461c14adba96670094ecd9a09beb2877e9cdde2d91844f8ef6a" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2981a6189a45a23557ce594478edfbc125fd4d4ce5c76f9534b62a00da81c40d.acl_profile_name
publish_topic_exception = "mco/*/*/*/contract/created/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_8f55b20bb0000c5c900eedadd6cee099827cb72c2b8c1ad752e492997e5ea3d3" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2981a6189a45a23557ce594478edfbc125fd4d4ce5c76f9534b62a00da81c40d.acl_profile_name
publish_topic_exception = "mco/*/*/*/contract/terminated/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_818e043f80b82bcde778f133fa5ead495ede911c2bbac64624bed653d4bdd4d1" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2981a6189a45a23557ce594478edfbc125fd4d4ce5c76f9534b62a00da81c40d.acl_profile_name
publish_topic_exception = "mco/*/*/*/contract/updated/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable client_password_8851da39225fe8ad {
}

variable client_username_8851da39225fe8ad {
}

variable username {
}

variable password {
}

variable url {
}
