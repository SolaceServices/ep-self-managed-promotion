terraform {
required_providers {
solacebroker = {
source = "registry.terraform.io/solaceproducts/solacebroker"
}
}
}

provider "solacebroker" {
alias = "id_r2zz1li0qq6"
username = "${var.username}"
password = "${var.password}"
url = "${var.url}"
skip_api_check = true
insecure_skip_verify = false
}

data "solacebroker_msg_vpn" "id_r2zz1li0qq6" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = "sandbox"
}

resource "solacebroker_msg_vpn_queue" "queue_27d4343d29fc831985f1b50f9b678d6d55b262b02b681a59d9d97680e7c71d75" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
owner = "EmployeeLifecycleManager"
queue_name = "Q.EMPLOYEE_LIFECYCLE_EVENTS"
access_type = "exclusive"
permission = "no-access"
egress_enabled = true
ingress_enabled = true
max_msg_spool_usage = 5000
}

resource "solacebroker_msg_vpn_queue_subscription" "sub_7131386580af40a63ad82f7f0a23c00647b0e8ef09d1efe2de9acca7165119a0" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_27d4343d29fc831985f1b50f9b678d6d55b262b02b681a59d9d97680e7c71d75.queue_name
subscription_topic = "acmeratings/hcm/employee/hired/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_3d06368e63347dd0ed1a63d53f3b82f53ea1fbfa4d1e82c06f80854166ca3840" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_27d4343d29fc831985f1b50f9b678d6d55b262b02b681a59d9d97680e7c71d75.queue_name
subscription_topic = "acmeratings/hcm/employee/promoted/v1/*/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_bce17c4d4bdee6614c6e4407ccc77793c42cdff2ae3c8bfad4e72ac9f1b000a1" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_27d4343d29fc831985f1b50f9b678d6d55b262b02b681a59d9d97680e7c71d75.queue_name
subscription_topic = "acmeratings/hcm/employee/terminated/v1/*/*/*"
}
resource "solacebroker_msg_vpn_queue_subscription" "sub_273ff0431aa30c7d76c150eac73c5ea3faae67ae27dbc4ea75d6809cd80eb860" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
queue_name = solacebroker_msg_vpn_queue.queue_27d4343d29fc831985f1b50f9b678d6d55b262b02b681a59d9d97680e7c71d75.queue_name
subscription_topic = "acmeratings/hcm/employee/transferred/v1/*/*/*/*"
}
data "solacebroker_msg_vpn_client_profile" "clientProfileName_37aac2d0ddfd2d9bffadd66a37daf33f35be42e40d1aedd3e884db47eff60cc5" {
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
provider = solacebroker.id_r2zz1li0qq6
client_profile_name = "default"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_322228ef3fac1fc5514f50a322376b4b8d228f61c4ef07f84d652c681804990f" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_37aac2d0ddfd2d9bffadd66a37daf33f35be42e40d1aedd3e884db47eff60cc5.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381.acl_profile_name
client_username = "${var.client_username_4d652c681804990f}"
password = "${var.client_password_4d652c681804990f}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381" {
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
provider = solacebroker.id_r2zz1li0qq6
acl_profile_name = "EmployeeLifecycleManager_acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_974ca3a9a447dff93cea79279303bc8ebb3b20f329b016294dd3bee2df915056"{
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/hired/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_5b552fb2b9579937caee213e8175d84094394031c8e0fd0500446e9aea2721d1"{
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/promoted/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_69d40c43cff2ccfa30a0b711dbb8d89fb93f870481ba8f215f102da6bbeb84f5"{
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/terminated/v1/*/*/*"
subscribe_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_subscribe_topic_exception" "subtopic_4199e45d0ed66849cacd615a191e85feff9dc089cc01445ff0f15b1a3c277d81"{
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_bc2c357079d7e2e5d65847c7ebba2c2c580832994e7cd789cf1b2d2ac1b30381.acl_profile_name
subscribe_topic_exception = "acmeratings/hcm/employee/transferred/v1/*/*/*/*"
subscribe_topic_exception_syntax = "smf"
}

variable client_username_4d652c681804990f {
}

variable client_password_4d652c681804990f {
}

variable username {
}

variable password {
}

variable url {
}
