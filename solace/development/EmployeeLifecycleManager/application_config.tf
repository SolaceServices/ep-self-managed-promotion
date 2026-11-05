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

resource "solacebroker_msg_vpn_queue" "queue_ad5a553f5968887b57e105e7408f4d5d11cf8817f6ed4a04266eae2e66792d9f" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
owner = "EmployeeLifecycleManager"
queue_name = "Q.EMPLOYEE_LIFECYCLE_EVENTS"
access_type = "exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_41fe76ad41fb60a9a1dc0928bedbab2f1ef1f52419f25e262e505edfc5d486e9" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_ad5a553f5968887b57e105e7408f4d5d11cf8817f6ed4a04266eae2e66792d9f.queue_name
subscription_topic = "acmeratings/hcm/employee/hired/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_dedbb6dd65877d88f396ff009a8bb6a2489596d205f3d7f41c0592fc455672d1" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_ad5a553f5968887b57e105e7408f4d5d11cf8817f6ed4a04266eae2e66792d9f.queue_name
subscription_topic = "acmeratings/hcm/employee/promoted/v1/*/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_0a82b45301549353cd537d56377521ca3a6885075cd751073cdeff294ca892f9" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_ad5a553f5968887b57e105e7408f4d5d11cf8817f6ed4a04266eae2e66792d9f.queue_name
subscription_topic = "acmeratings/hcm/employee/terminated/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_2a52d973839ebace33466e7400636bc12aa6f55c2cb58fb1a32080be445beb7c" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_ad5a553f5968887b57e105e7408f4d5d11cf8817f6ed4a04266eae2e66792d9f.queue_name
subscription_topic = "acmeratings/hcm/employee/transferred/v1/*/*/*/*"
}
data "solacebroker_msg_vpn_client_profile" "clientProfileName_937eff59e5f99839b9f0bb3ac1572fcd79f212d0f2da17ec6edf4327d50d1442" {
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
provider = solacebroker.id_9on7jb3s886
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_5abd71381ec9d8d426d4adf44cce202e6dd8ba29fe5ef6cad7b6b188887f4c41" {
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_937eff59e5f99839b9f0bb3ac1572fcd79f212d0f2da17ec6edf4327d50d1442.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6.acl_profile_name
client_username = "${var.client_username_d7b6b188887f4c41}"
password = "${var.client_password_d7b6b188887f4c41}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6" {
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
provider = solacebroker.id_9on7jb3s886
acl_profile_name = "EmployeeLifecycleManager_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_c53b2198905e1215d7461d3b4d84c9aedd9493bfe22cac8ff85cb8c82484929a"{
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/hired/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_2116b38b03a69ad89e96e11232fb35ed44e270fb0348ae18997eb9cdb0468d6e"{
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/promoted/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_e2dc83627f0d1dd7f25d9e6a309e7c72d138e54d71e573ab4ee6989f0578acd5"{
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/terminated/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_538cae3040ceb484b2d553f232c16aed37da7dc26d1895e1e93007951de1f919"{
provider = solacebroker.id_9on7jb3s886
msg_vpn_name = data.solacebroker_msg_vpn.id_9on7jb3s886.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_eec08e9b23963c4a76fadb6e3f874ae03eb8b5e445d33419500f718ae8b4b3f6.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/transferred/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}

variable client_password_d7b6b188887f4c41 {
}

variable client_username_d7b6b188887f4c41 {
}

variable username {
}

variable password {
}

variable url {
}
