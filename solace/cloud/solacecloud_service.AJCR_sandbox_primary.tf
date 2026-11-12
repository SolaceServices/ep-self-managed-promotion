resource "solacecloud_service" "AJCR_sandbox_primary" {
  name                 = "AJCR_sandbox_primary"
  datacenter_id        = "eks-ca-central-1a"
  service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.25.0.123-19"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = true
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = true
  cluster_name         = "cluster-eks-ca-central-1a-foeb97bgnth"
  mate_link_encryption = true
  environment_id       = "jz2r4v8v5rg"
}

import {
  to = solacecloud_service.AJCR_sandbox_primary
  id = "42g9f4gnqy3"
}

resource "solacecloud_connection_endpoint" "AJCR_sandbox_primary_Public_Endpoint" {
  service_id  = solacecloud_service.AJCR_sandbox_primary.id
  access_type = "PUBLIC"
  name        = "Public Endpoint"

  ports = {
    management_tls = {
      port = 943
    }
    ssh_tls = {
      port = 2222
    }
    smf = {
      port = 55555
    }
    smf_tls = {
      port = 55443
    }
    smf_compressed = {
      port = 55003
    }
    rest_incoming_tls = {
      port = 9443
    }
    web_tls = {
      port = 443
    }
  }
}

import {
  to = solacecloud_connection_endpoint.AJCR_sandbox_primary_Public_Endpoint
  id = "42g9f4gnqy3/connectionEndpoints/21b1bkce55l"
}

resource "solacecloud_connection_endpoint_dns_name" "AJCR_sandbox_primary_Public_Endpoint_dns_ajcr-sandbox-primary_messaging_solace_cloud" {
  service_id             = solacecloud_service.AJCR_sandbox_primary.id
  connection_endpoint_id = solacecloud_connection_endpoint.AJCR_sandbox_primary_Public_Endpoint.id
  dns_name               = "ajcr-sandbox-primary.messaging.solace.cloud"
}

import {
  to = solacecloud_connection_endpoint_dns_name.AJCR_sandbox_primary_Public_Endpoint_dns_ajcr-sandbox-primary_messaging_solace_cloud
  id = "42g9f4gnqy3/21b1bkce55l/ajcr-sandbox-primary.messaging.solace.cloud"
}
