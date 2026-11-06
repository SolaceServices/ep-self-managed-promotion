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
resource "solacebroker_msg_vpn_authorization_group" "authgroup_cf4a657836f66457d71a1a26ea0107bf40a00d7aae38f443d7ba98e2bef0610d"{
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
provider = solacebroker.id_r2zz1li0qq6
client_profile_name = data.solacebroker_msg_vpn_client_profile.clientProfileName_7e60c4ea0e0fedf2085a24464438f8fc519fb94387bbb39eb41b6bef3ca34710.client_profile_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
enabled = true
authorization_group_name = "oauth-workday"
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
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_6650ad26af8be25e672b5cedc12343d6d8fb3d0496c6cb01da18af225e0204bb" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "acmeratings/hcm/employee/hired/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_a1326670bcce1b5df3c3a4758f68e41ad7655607502012aec235288944ef0c91" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "acmeratings/hcm/employee/promoted/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_0b3261ca17ccf7bf459f928d4412ebdbd34505706371c1a6a5f9a68e241f8bff" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "acmeratings/hcm/employee/terminated/v1/*/*/*"
publish_topic_exception_syntax = "smf"
}
resource "solacebroker_msg_vpn_acl_profile_publish_topic_exception" "pubtopic_e2d555d0c42b1cc7af96772047426d896ccf2da221793081c765d551fb047478" {
provider = solacebroker.id_r2zz1li0qq6
msg_vpn_name = data.solacebroker_msg_vpn.id_r2zz1li0qq6.msg_vpn_name
acl_profile_name = resource.solacebroker_msg_vpn_acl_profile.aclProfileName_52f4c32f416116575d2c5b42e4cf96cb2a67222825e209ca336704545d65340b.acl_profile_name
publish_topic_exception = "acmeratings/hcm/employee/transferred/v1/*/*/*/*"
publish_topic_exception_syntax = "smf"
}

variable username {
}

variable password {
}

variable url {
}
