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

resource "solacebroker_msg_vpn_queue" "queue_552e1702d7cafe9e931e788f1882d0bce7fe9940fb155d0e57f2fc75c70dc1cf" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
owner = "contract_p_app"
queue_name = "Q.CONTRACT_PROCESSOR_CREATION"
access_type = "exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_37c53ef69a63df0d3bc585b45eb15461a16f4ebeb5f1298d9642bb6c73915e01" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_552e1702d7cafe9e931e788f1882d0bce7fe9940fb155d0e57f2fc75c70dc1cf.queue_name
subscription_topic = "mco/*/*/*/contract/created/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue" "queue_04225ff2b2fd7074286fc2a696d0201d9fd53e236c278f7c03fe0a0999a2486c" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
owner = "contract_p_app"
queue_name = "Q.CONTRACT_PROCESSOR_TERMINATION"
access_type = "exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_f589db863b1413c69b3b631023ef4108f8ca553e2cfa58336098862c7407cdcf" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_04225ff2b2fd7074286fc2a696d0201d9fd53e236c278f7c03fe0a0999a2486c.queue_name
subscription_topic = "mco/*/*/*/contract/terminated/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue" "queue_36621242b58447ef37759a7a9895719b30fb66f70e69d942a62f47532a3465fb" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
owner = "contract_p_app"
queue_name = "Q.CONTRACT_PROCESSOR_UPDATE"
access_type = "exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_bfca1d3012bf8ef1c15af8c604e3a0c154521294eff099d539181f27d4d20aa8" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_36621242b58447ef37759a7a9895719b30fb66f70e69d942a62f47532a3465fb.queue_name
subscription_topic = "mco/*/*/*/contract/updated/v1/*/*/*"
}
data "solacebroker_msg_vpn_client_profile" "clientProfileName_bd47d890cf14b6915d722b9d5964ac17b8e6f2200de1db870b5f84e899338023" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_92e903f0670fe52e0dd9f9b865d42b3c678de44147126802d02925d6c4a13533" {
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_bd47d890cf14b6915d722b9d5964ac17b8e6f2200de1db870b5f84e899338023.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2b4f31959867fb93a7958c072c4dfd6604ec3fa1920e0a26eef2c7af986a57a1.acl_profile_name
client_username = "${var.client_username_d02925d6c4a13533}"
password = "${var.client_password_d02925d6c4a13533}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_2b4f31959867fb93a7958c072c4dfd6604ec3fa1920e0a26eef2c7af986a57a1" {
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
provider = solacebroker.id_fgnr93258z2
acl_profile_name = "contract_p_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_4daaf22e6039f710a3d12f2be20ca97b3df8c08e7273738f467f92c19181d1a6"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2b4f31959867fb93a7958c072c4dfd6604ec3fa1920e0a26eef2c7af986a57a1.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/contract/created/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_bcff88cf8d6fea660b5d005002dd734a64d8430fcd6ca5376062a017381a66b1"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2b4f31959867fb93a7958c072c4dfd6604ec3fa1920e0a26eef2c7af986a57a1.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/contract/terminated/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_19d4a64269270c704d95fa21deacc7db2ac0d558f7a6d522b620480075893908"{
provider = solacebroker.id_fgnr93258z2
msg_vpn_name = data.solacebroker_msg_vpn.id_fgnr93258z2.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_2b4f31959867fb93a7958c072c4dfd6604ec3fa1920e0a26eef2c7af986a57a1.acl_profile_name
subscribe_topic_exception = "mco/*/*/*/contract/updated/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}

variable client_password_d02925d6c4a13533 {
}

variable client_username_d02925d6c4a13533 {
}

variable username {
}

variable password {
}

variable url {
}
