
# Azure AD application ID.
output "server_app_id" {
  value = "${azuread_application.aks_aad_srv.application_id}"
}

# Azure AD Client ID.
output "client_app_id" {
  value = "${azuread_application.aks_aad_client.application_id}"
}

# Tenant ID of current client.
output "tenant_id" {
   value = "${data.azurerm_subscription.current.tenant_id}"
}

# Server App secret.
output "server_app_secret" {
   value = "${random_password.aks_aad_srv.result}"
}

# Service Principal Client ID.
output "service_prinicipal_client_id" {
   value = "${azuread_application.aks_sp.application_id}"
}

# Service Principal Client Secret.
output "service_prinicipal_client_secret" {
   value = "${random_password.aks_sp_pwd.result}"
}
