resource "solacecloud_service" "AJCR_sandbox_backup" {
  name                 = "AJCR_sandbox_backup"
  datacenter_id        = "aks-eastus"
  service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.25.0.148-27"
  message_vpn_name     = "sandbox"
  max_spool_usage      = 50
  locked               = true
  owned_by             = "9uz252oc2mi"
  dmr_enabled          = true
  cluster_name         = "cluster-aks-eastus-second-dc-54bars4cq0a"
  mate_link_encryption = false
}

import {
  to = solacecloud_service.AJCR_sandbox_backup
  id = "93d9izy96vf"
}

resource "solacecloud_connection_endpoint" "AJCR_sandbox_backup_Default_Public" {
  service_id  = solacecloud_service.AJCR_sandbox_backup.id
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
  to = solacecloud_connection_endpoint.AJCR_sandbox_backup_Default_Public
  id = "93d9izy96vf/connectionEndpoints/9koibx6n967"
}
