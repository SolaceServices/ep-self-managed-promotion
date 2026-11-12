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

resource "solacebroker_msg_vpn_queue" "queue_a824a6b016a91412161abd6f54180f000cb15aa96fb91f5ef4e99d5c680bf843" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
owner = "EmployeeLifecycleManager"
queue_name = "Q.ELM_EMPLOYEE_EVENTS"
access_type = "non-exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_45d0e7a7390990e24cde0d850d93f91d262e4fcbbbcb4624571ef90d24128def" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_a824a6b016a91412161abd6f54180f000cb15aa96fb91f5ef4e99d5c680bf843.queue_name
subscription_topic = "mco/*/*/*/employee/hired/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_e20f1387c5953d418ee922e1d1df4624ed5eac3758006b23e7b7d39ad205ad38" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_a824a6b016a91412161abd6f54180f000cb15aa96fb91f5ef4e99d5c680bf843.queue_name
subscription_topic = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_a4e6cf7c54e5503dbeda1af07c9dcfd1baea234e6c2764e8e57207d68d3f9ac6" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_a824a6b016a91412161abd6f54180f000cb15aa96fb91f5ef4e99d5c680bf843.queue_name
subscription_topic = "mco/*/*/*/employee/terminated/v1/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_07eba6a6042cde905b426dcd1b1daef1f2cf82cde34f097b7ed449d5baba1338" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_a824a6b016a91412161abd6f54180f000cb15aa96fb91f5ef4e99d5c680bf843.queue_name
subscription_topic = "mco/*/*/*/employee/transferred/v1/*/*/*"
}
data "solacebroker_msg_vpn_client_profile" "clientProfileName_41a49a0fb509da778dc9be39dfef5749b5a24dcffc1132a06375e4d732df9615" {
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
provider = solacebroker.id_h50s5r5w34l
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_2700030c87447c16098e5e643fbed91aaa8b44393d62158d7e9932542053790d" {
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_41a49a0fb509da778dc9be39dfef5749b5a24dcffc1132a06375e4d732df9615.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7.acl_profile_name
client_username = "${var.client_username_7e9932542053790d}"
password = "${var.client_password_7e9932542053790d}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7" {
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
provider = solacebroker.id_h50s5r5w34l
acl_profile_name = "EmployeeLifecycleManager_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_2b6c2bb4a8ff4f21b00cdca1df6d9e96784ae41919088de76f043b6ac8963f97"{
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_d0a76135d3fbd7f7a69221306d7562c7acdd1398b812538d08e8e853f402fa10"{
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_e9816b175fa829fec6ebdbf127515a3639f1760718f2e101d93425c6deb62634"{
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_966aa1d8041e38a5f59674fd9bc1b3f7d8731310ddd7fe556331c87b4a87f92a"{
provider = solacebroker.id_h50s5r5w34l
msg_vpn_name = data.solacebroker_msg_vpn.id_h50s5r5w34l.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2c49414d1aa160876fa7e81bd611ab5da60c0498af63f06f82ead85a56c8ede7.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}

variable client_username_7e9932542053790d {
}

variable client_password_7e9932542053790d {
}

variable username {
}

variable password {
}

variable url {
}
