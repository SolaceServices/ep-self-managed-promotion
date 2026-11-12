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

data "solacebroker_msg_vpn_client_profile" "clientProfileName_9b608d598a1a94d2d8a1ba55dcca112bd4f48827ef88b373b7da82ea795b3414" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_49055a9c3109ea84113e7834d9ade7b9d1c86576518d9d11bf145148e4e9b823" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_9b608d598a1a94d2d8a1ba55dcca112bd4f48827ef88b373b7da82ea795b3414.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee.acl_profile_name
client_username = "${var.client_username_bf145148e4e9b823}"
password = "${var.client_password_bf145148e4e9b823}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
acl_profile_name = "workday_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_e0232e9efcaf92c8b85ea13503cbdb08fbbe7fac04595788e659419884cc5eb5" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_9f7eb77c14376554b427c074ea742e52656ecad024d426616485f4495501b7a2" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_8a9f32c9295498dd9674e81dec89ef051b4369a10a9a51d0d918612bb3b83434" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_a77e8f72f771e6298c0bec0c399ada29065e1a20b3fc6f3f92f38b55776a6cdd" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_81aeeda549baf2a6d02cefab5378283310e1350ad58992a0d9178a5a7b9e91ee.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable client_password_bf145148e4e9b823 {
}

variable client_username_bf145148e4e9b823 {
}

variable username {
}

variable password {
}

variable url {
}
