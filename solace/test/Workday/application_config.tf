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

data "solacebroker_msg_vpn_client_profile" "clientProfileName_7e60c4ea0e0fedf2085a24464438f8fc519fb94387bbb39eb41b6bef3ca34710" {
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
provider = solacebroker.id_r2zz1li0qq6
client_profile_name = "workday_cp"
}
resource "solacebroker_msg_vpn_client_username" "clientuserName_74f6411ad90d3a19798733ac0dcd4db7047733f0a189f18fc6da4a351d5460bd" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_7e60c4ea0e0fedf2085a24464438f8fc519fb94387bbb39eb41b6bef3ca34710.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
client_username = "${var.client_username_c6da4a351d5460bd}"
password = "${var.client_password_c6da4a351d5460bd}"
enabled = true
subscription_manager_enabled = false
guaranteed_endpoint_permission_override_enabled = false
}
resource "solacebroker_msg_vpn_acl_profile" "aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b" {
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
provider = solacebroker.id_r2zz1li0qq6
acl_profile_name = "workday-acl"
publish_topic_default_action = "disallow"
client_connect_default_action = "allow"
subscribe_topic_default_action = "disallow"
subscribe_share_name_default_action = "allow"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_46be848f647b998c0dedd4426b8d123823473f6a9f2c56440c54ce8923e35b10" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/hired/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_2935eca622c98f37088030cc19e3a3d19892f4b1b7fd3187281c7b413b46b3f0" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/promoted/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_c0551af6650af380203847960810b5e0f3aaa6c35f97265b14a685e93451c730" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/terminated/v1/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_9d036167deb4ab9be97af71375b61842b93c4d27a3f9d0b97dee58522578d785" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "mco/*/*/*/employee/transferred/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable client_username_c6da4a351d5460bd {
}

variable client_password_c6da4a351d5460bd {
}

variable username {
}

variable password {
}

variable url {
}
