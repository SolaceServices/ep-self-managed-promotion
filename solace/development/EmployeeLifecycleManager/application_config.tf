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

resource "solacebroker_msg_vpn_queue" "queue_384bf426a270805367f5fe15432604153a8f4af259128edbd7c9feff41abb48a" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
owner = "EmployeeLifecycleManager"
queue_name = "Q.ELM_EMPLOYEE_EVENTS"
access_type = "non-exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_a42378d1401bcb0a154b74794d62c092aa9ea263370ecc1131432ae09a94ab66" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_384bf426a270805367f5fe15432604153a8f4af259128edbd7c9feff41abb48a.queue_name
subscription_topic = "mco/*/*/*/employee/hired/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_cc05b26a830f806122a1289df2cd3a8eaf4ab9e4260e52551bb780bbbfb6d819" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_384bf426a270805367f5fe15432604153a8f4af259128edbd7c9feff41abb48a.queue_name
subscription_topic = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_1b40e27e874c55ecd1ce345d590b34685fc02360a6a7a7225f3fb5643fd2d59b" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_384bf426a270805367f5fe15432604153a8f4af259128edbd7c9feff41abb48a.queue_name
subscription_topic = "mco/*/*/*/employee/terminated/v1/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_46f64f5388d0673e31ff90e38354e6d9a66d8e8cf9b84d643e60b3a66f55bfb1" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_384bf426a270805367f5fe15432604153a8f4af259128edbd7c9feff41abb48a.queue_name
subscription_topic = "mco/*/*/*/employee/transferred/v1/*/*/*"
}
data "solacebroker_msg_vpn_client_profile" "clientProfileName_ced816742809c2b9e03945ef01153184df0373b1f4623318ca028a067e2bbace" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_4fc368beda608e388e6af1fbbf14e326ec337f94a29693e86d494d1101452bbc" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_ced816742809c2b9e03945ef01153184df0373b1f4623318ca028a067e2bbace.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01.acl_profile_name
client_username = "${var.client_username_6d494d1101452bbc}"
password = "${var.client_password_6d494d1101452bbc}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
acl_profile_name = "EmployeeLifecycleManager_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_d65b152f4b3f1e56d54016c90b42be253e9128f8c21e70c90ba0cd5330ea113c"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_3f7eb7385b80e111d2889a0d08c35d9ff69d9d928032e3f0fe2e8072d89c1745"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_e1f77c59731de016f1ea3440c48a4b8e2b888c96d8e9d0f17cb4686cbf00e685"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_23ff984ac0a39c0e32e4aff2bbcd6fa33fa8764adb42542da6ef650e526167d9"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_56e50466bd9a899ee82697471a2fdfcda80a21c811449bc95a14ac402245da01.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}

variable client_password_6d494d1101452bbc {
}

variable client_username_6d494d1101452bbc {
}

variable username {
}

variable password {
}

variable url {
}
