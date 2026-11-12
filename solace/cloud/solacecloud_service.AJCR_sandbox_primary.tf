resource "solacecloud_service" "AJCR_sandbox_primary" {
  name                 = "AJCR_sandbox_primary"
  datacenter_id        = "eks-ca-central-1a"
  service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9219-22"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = true
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = true
  cluster_name         = "cluster-eks-ca-central-1a-foeb97bgnth"
  mate_link_encryption = true
  environment_id       = "56hf9w4m179"
}

import {
  to = solacecloud_service.AJCR_sandbox_primary
  id = "3p6muksahbi"
}

resource "solacecloud_connection_endpoint" "AJCR_sandbox_primary_Default_Public" {
  service_id  = solacecloud_service.AJCR_sandbox_primary.id
  access_type = "PUBLIC"
  name        = "Default Public"

  ports = {
    management_tls = {
      port = 943
    }
    ssh_tls = {
      port = 22
    }
    smf_tls = {
      port = 55443
    }
    mqtt_tls = {
      port = 8883
    }
    mqtt_websocket_tls = {
      port = 8443
    }
    amqp_tls = {
      port = 5671
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
  to = solacecloud_connection_endpoint.AJCR_sandbox_primary_Default_Public
  id = "3p6muksahbi/connectionEndpoints/ptx652y6657"
}

resource "solacecloud_connection_endpoint_dns_name" "AJCR_sandbox_primary_Default_Public_dns_ajcr-sandbox-primary_messaging_solace_cloud" {
  service_id             = solacecloud_service.AJCR_sandbox_primary.id
  connection_endpoint_id = solacecloud_connection_endpoint.AJCR_sandbox_primary_Default_Public.id
  dns_name               = "ajcr-sandbox-primary.messaging.solace.cloud"
}

import {
  to = solacecloud_connection_endpoint_dns_name.AJCR_sandbox_primary_Default_Public_dns_ajcr-sandbox-primary_messaging_solace_cloud
  id = "3p6muksahbi/ptx652y6657/ajcr-sandbox-primary.messaging.solace.cloud"
}
