resource "solacecloud_service" "AJCR_sandbox_primary" {
  name             = "AJCR_sandbox_primary"
  datacenter_id    = "eks-ca-central-1a"
  service_class_id = "ENTERPRISE_250_HIGHAVAILABILITY"
  event_broker_version = "10.25.0.123-19"
  message_vpn_name = "sandbox"
}

import {
  to = solacecloud_service.AJCR_sandbox_primary
  id = "42g9f4gnqy3"
}
