resource "solacecloud_service" "ajcr_sandbox_backup_01" {
  name                 = "ajcr_sandbox_backup_01"
  datacenter_id        = "aks-eastus"
  service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.25.0.411-60"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = false
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = true
  cluster_name         = "cluster-aks-eastus-second-dc-e3ywbz3824o"
  mate_link_encryption = true
  environment_id       = "56hf9w4m179"
}

import {
  to = solacecloud_service.ajcr_sandbox_backup_01
  id = "qmq8eto05ob"
}

resource "solacecloud_connection_endpoint" "ajcr_sandbox_backup_01_Public_Endpoint" {
  service_id  = solacecloud_service.ajcr_sandbox_backup_01.id
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
  to = solacecloud_connection_endpoint.ajcr_sandbox_backup_01_Public_Endpoint
  id = "qmq8eto05ob/connectionEndpoints/p0efdlg31i5"
}
