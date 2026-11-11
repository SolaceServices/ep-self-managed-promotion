# solacecloud_service.AJCR_sandbox_backup:
resource "solacecloud_service" "AJCR_sandbox_backup" {
    cluster_name         = "cluster-aks-eastus-second-dc-54bars4cq0a"
    datacenter_id        = "aks-eastus"
    dmr_cluster          = {
        name                           = "cluster-aks-eastus-second-dc-54bars4cq0a"
        password                       = (sensitive value)
        primary_router_name            = "93d9izy96vfprimary"
        remote_address                 = "mr-connection-9koibx6n967.messaging.solace.cloud"
        supported_authentication_modes = [
            "Basic",
        ]
    }
    dmr_enabled          = true
    environment_id       = "1900fa9xvc7"
    event_broker_version = "10.25.0.148-27"
    id                   = "93d9izy96vf"
    locked               = true
    mate_link_encryption = false
    max_spool_usage      = 50
    message_vpn          = {
        authentication_basic_enabled                     = true
        authentication_basic_type                        = "INTERNAL"
        authentication_client_cert_enabled               = false
        authentication_client_cert_validate_date_enabled = false
        editor_management_credential                     = {
            password = (sensitive value)
            username = "sandbox-admin"
        }
        manager_management_credential                    = {
            password = (sensitive value)
            username = "mission-control-manager"
        }
        max_connection_count                             = 250
        max_egress_flow_count                            = 250
        max_endpoint_count                               = 250
        max_ingress_flow_count                           = 250
        max_msg_spool_usage                              = 50000
        max_subscription_count                           = 50000
        max_transacted_session_count                     = 500
        max_transaction_count                            = 2500
        messaging_client_credential                      = {
            password = (sensitive value)
            username = "solace-cloud-client"
        }
        name                                             = "sandbox"
        truststore_uri                                   = "https://cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem"
        viewer_management_credential                     = {
            password = (sensitive value)
            username = "sandbox-view"
        }
    }
    message_vpn_name     = "sandbox"
    name                 = "AJCR_sandbox_backup"
    owned_by             = "9uz252oc2mi"
    service_class_id     = "ENTERPRISE_250_HIGHAVAILABILITY"
}
