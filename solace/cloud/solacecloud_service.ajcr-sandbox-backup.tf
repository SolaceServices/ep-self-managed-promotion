resource "solacecloud_service" "ajcr-sandbox-backup" {
  name             = "ajcr-sandbox-backup"
  datacenter_id    = "eks-us-west-1a"
  service_class_id = "ENTERPRISE_1K_HIGHAVAILABILITY"
  event_broker_version = "10.26.0.9163-20"
  message_vpn_name = "sandbox"
}

import {
  to = solacecloud_service.ajcr-sandbox-backup
  id = "1v529q5sp6e"
}
