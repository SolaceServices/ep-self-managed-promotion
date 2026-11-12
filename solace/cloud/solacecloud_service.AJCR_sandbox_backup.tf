resource "solacecloud_service" "AJCR_sandbox_backup" {
  name                 = "AJCR_sandbox_backup"
  datacenter_id        = "aks-eastus"
  service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9219-22"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = true
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = false
  mate_link_encryption = true
  environment_id       = "56hf9w4m179"
}

import {
  to = solacecloud_service.AJCR_sandbox_backup
  id = "fbvqj8rqqtu"
}

resource "solacecloud_connection_endpoint" "AJCR_sandbox_backup_Public_Endpoint" {
  service_id  = solacecloud_service.AJCR_sandbox_backup.id
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
  to = solacecloud_connection_endpoint.AJCR_sandbox_backup_Public_Endpoint
  id = "fbvqj8rqqtu/connectionEndpoints/imwxavuxc2g"
}

resource "solacecloud_connection_endpoint_dns_name" "AJCR_sandbox_backup_Public_Endpoint_dns_ajcr-sandbox-backup_messaging_solace_cloud" {
  service_id             = solacecloud_service.AJCR_sandbox_backup.id
  connection_endpoint_id = solacecloud_connection_endpoint.AJCR_sandbox_backup_Public_Endpoint.id
  dns_name               = "ajcr-sandbox-backup.messaging.solace.cloud"
}

import {
  to = solacecloud_connection_endpoint_dns_name.AJCR_sandbox_backup_Public_Endpoint_dns_ajcr-sandbox-backup_messaging_solace_cloud
  id = "fbvqj8rqqtu/imwxavuxc2g/ajcr-sandbox-backup.messaging.solace.cloud"
}
