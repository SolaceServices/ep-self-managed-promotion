resource "solacecloud_service" "ajcr-sandbox-backup" {
  name                 = "ajcr-sandbox-backup"
  datacenter_id        = "eks-us-west-1a"
  service_class_id     = "ENTERPRISE_1K_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9219-22"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = false
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = false
  mate_link_encryption = true
  environment_id       = "yt7nhpcyoyc"
}

import {
  to = solacecloud_service.ajcr-sandbox-backup
  id = "e4m97f023ea"
}

resource "solacecloud_connection_endpoint" "ajcr-sandbox-backup_Public_Endpoint" {
  service_id  = solacecloud_service.ajcr-sandbox-backup.id
  access_type = "PUBLIC"
  name        = "Public Endpoint"

  ports = {
    management_tls = {
      port = 943
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
  to = solacecloud_connection_endpoint.ajcr-sandbox-backup_Public_Endpoint
  id = "e4m97f023ea/connectionEndpoints/r3280oy2n09"
}
