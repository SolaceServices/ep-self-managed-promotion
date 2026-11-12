resource "solacecloud_service" "ajcr-sandbox-primary" {
  name                 = "ajcr-sandbox-primary"
  datacenter_id        = "eks-us-east-1a"
  service_class_id     = "ENTERPRISE_1K_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9163-20"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 200
  locked               = true
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = false
  mate_link_encryption = false
}

import {
  to = solacecloud_service.ajcr-sandbox-primary
  id = "feg86kv3o2m"
}

resource "solacecloud_connection_endpoint" "ajcr-sandbox-primary_Default_Public" {
  service_id  = solacecloud_service.ajcr-sandbox-primary.id
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
  to = solacecloud_connection_endpoint.ajcr-sandbox-primary_Default_Public
  id = "feg86kv3o2m/connectionEndpoints/h8bta2ve6n9"
}
