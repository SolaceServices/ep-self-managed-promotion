resource "solacecloud_service" "ajcr-sandbox-primary" {
  name             = "ajcr-sandbox-primary"
  datacenter_id    = "eks-us-east-1a"
  service_class_id = "ENTERPRISE_1K_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9163-20"
  message_vpn_name = "sandbox"
}

import {
  to = solacecloud_service.ajcr-sandbox-primary
  id = "feg86kv3o2m"
}
