
# Get the Current subscription and tanent ID.
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Create the Azure AD application Server.
resource azuread_application aks_aad_srv {
  name                       = "${var.resource_prefix}srv"
  homepage                   = "https://${var.resource_prefix}srv"
  identifier_uris            = ["https://${var.resource_prefix}srv"]
  reply_urls                 = ["https://${var.resource_prefix}srv"]
  type                       = "webapp/api"
  group_membership_claims    = "All"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false

  # MicrosoftGraph API
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    # APPLICATION PERMISSIONS: "Read directory data":
    # 7ab1d382-f21e-4acd-a863-ba3e13f7da61
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }

    # DELEGATED PERMISSIONS: "Read directory data":
    # 06da0dbc-49e2-44d2-8312-53f166ab848a
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }

    # DELEGATED PERMISSIONS: "Sign in and read user profile":
    # e1fe6dd8-ba31-4d61-89e7-88639da4683d
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  # Windows Azure Active Directory API
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    # DELEGATED PERMISSIONS: "Sign in and read user profile":
    # 311a71cc-e848-46a1-bdf8-97ff7156d8e6
    resource_access {
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }

}


# Associate the Service Principal with Application Azure AD.
resource azuread_service_principal aks_aad_srv {
  application_id = azuread_application.aks_aad_srv.application_id
}

# Get the random password for secret.
resource random_password aks_aad_srv {
  length  = 16
  special = true
}

# Manages a Password associated with an Application within Azure Active Directory
resource azuread_application_password aks_aad_srv {
  application_object_id = azuread_application.aks_aad_srv.object_id
  value                 = random_password.aks_aad_srv.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years
}


# Create the Azure AD application Client.
resource azuread_application aks_aad_client {
  name       = "${var.resource_prefix}client"
  homepage   = "https://${var.resource_prefix}client"
  reply_urls = ["https://${var.resource_prefix}client"]
  type       = "native"

  # Windows Azure Active Directory API
  required_resource_access {

    # AKS ad application server
    resource_app_id = azuread_application.aks_aad_srv.application_id

    # Server app Oauth2 permissions id
    resource_access {
      id   = azuread_application.aks_aad_srv.oauth2_permissions.0.id
      type = "Scope"
    }
  }
}

# Associate the Service Principal with Client Azure AD.
resource azuread_service_principal aks_aad_client {
  application_id = azuread_application.aks_aad_client.application_id
}

# AAD K8s cluster admin group / AAD
resource azuread_group aks_aad_clusteradmins {
  name = "${var.resource_prefix}clusteradmin"
}

#resource azuread_group  aks_aad_opssre {
#  name    = "${var.resource_prefix}opssre"
#}

#resource azuread_group  aks_aad_opsdev {
#  name    = "${var.resource_prefix}opsdev"
#}

# Create a service principal for the Azure AD application.
resource azuread_application aks_sp {
  name                       = var.resource_prefix
  homepage                   = "https://${var.resource_prefix}"
  identifier_uris            = ["https://${var.resource_prefix}"]
  reply_urls                 = ["https://${var.resource_prefix}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

# Manages a Service Principal associated with an Application within Azure Active Directory
resource azuread_service_principal aks_sp {
  application_id = azuread_application.aks_sp.application_id
}

# Get the random password for secret.
resource random_password aks_sp_pwd {
  length  = 16
  special = true
}

# Manages a Password associated with a Service Principal within Azure Active Directory.
resource azuread_service_principal_password aks_sp_pwd {
  service_principal_id = azuread_service_principal.aks_sp.id
  value                = random_password.aks_sp_pwd.result
  end_date             = timeadd(timestamp(), "87600h") # 10 years
}

# Assigns a given Principal (User or Application) to a given Role
resource azurerm_role_assignment aks_sp_role_assignment {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aks_sp.id

  depends_on = [
    azuread_service_principal_password.aks_sp_pwd
  ]
}

# Before giving consent, wait. Sometimes Azure returns a 200, but not all services have access to the newly created applications/services.
resource "null_resource" "delay_before_consent" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    azuread_service_principal.aks_aad_srv,
    azuread_service_principal.aks_aad_client
  ]
}


# Give admin consent - SP/az login user must be AAD admin
resource "null_resource" "grant_srv_admin_constent" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.aks_aad_srv.application_id}"
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
}

resource "null_resource" "grant_client_admin_constent" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.aks_aad_client.application_id}"
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
}

# Again, wait for a few seconds...
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    null_resource.grant_srv_admin_constent,
    null_resource.grant_client_admin_constent
  ]
}
