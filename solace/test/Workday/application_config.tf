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

data "solacebroker_msg_vpn_client_profile" "clientProfileName_b0ffb1b438d7dcb5f7718ca5a3886a2e465f9eb231a038c1940f10df70d16618" {
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
provider = solacebroker.id_h50s5r5w34l
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_979d34c9f51757a1d4472cb5144bd12115e65a20e072fa0cd4b91fb5b4a9ba13" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_b0ffb1b438d7dcb5f7718ca5a3886a2e465f9eb231a038c1940f10df70d16618.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4.acl_profile_name
client_username = "${var.client_username_d4b91fb5b4a9ba13}"
password = "${var.client_password_d4b91fb5b4a9ba13}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4" {
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
provider = solacebroker.id_h50s5r5w34l
acl_profile_name = "workday_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_910e0f61dd188d494b3b7a5242807f8ce710443571daa75ec9f4c8326d1a29f1" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_b1339ea85d2960c04de12bc7b584cceb2950ff788ff7b95b0220e9df0ada7cc4" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_7234b786de6d1cea265d31c76128e5e73cab050a45e10bab6089cac43b9fd132" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_2a01af727ec1df70ca724097437ef752809d1ca82037987d20ec81c6e8283adc" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_b858b20f6e5c0efbeb116d99735a5c45d51f835fa02b1703a77e8bb678f1c5f4.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable client_password_d4b91fb5b4a9ba13 {
}

variable client_username_d4b91fb5b4a9ba13 {
}

variable username {
}

variable password {
}

variable url {
}
