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

data "solacebroker_msg_vpn_client_profile" "clientProfileName_2cefeeb93d42a9764d5f4c527b12d943edfd0ebe24309f9e4cb3739fa9dea735" {
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
provider = solacebroker.id_9on7jb3s886
client_profile_name = "workday_cp"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_ce5427fc51591f735cfd13d29e8f4458875feea09d0908cd9177c5545ebb462b" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_2cefeeb93d42a9764d5f4c527b12d943edfd0ebe24309f9e4cb3739fa9dea735.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91.acl_profile_name
client_username = "${var.client_username_9177c5545ebb462b}"
password = "${var.client_password_9177c5545ebb462b}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91" {
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
provider = solacebroker.id_9on7jb3s886
acl_profile_name = "workday-acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_4d4883009cbe75ca3d6e8cce5b9c5861520e6d63d1bd85534d0ddf0652700e9e" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_3c70fa8863e80023666301a465cbf36acf2334e2eb2000c021c916bab15ca8eb" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_b4d0a07dcacf22d469c9ef7b26f1a95a203c76910319f0bb71f5a50e9410848e" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_39d6e28887d0c09b720f8a88c4f66b27e229ab861f2fc7be65dbe63e455c1f0f" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b8c7ca31a79ba371c09d640420ec11c03438a46f4d27f59a254a821942123b91.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable client_username_9177c5545ebb462b {
}

variable client_password_9177c5545ebb462b {
}

variable username {
}

variable password {
}

variable url {
}
