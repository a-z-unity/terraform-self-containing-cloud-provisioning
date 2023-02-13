terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2"
    }
  }

  backend "azurerm" { }
}

provider "azurerm" {
  features {}
}

variable "subscription_id" {
  type = string
}

variable "owners" {
  type = string
  validation {
    condition     = length(split(",", var.owners)) > 0
    error_message = "'contributors' should contains 1 or more values"
  }
  validation {
    condition     = min([for item in split(",", var.owners) : length(item)]...) >= 5
    error_message = "length of each owner should be 5 or more"
  }
  validation {
    condition     = max([for item in split(",", var.owners) : length(item)]...) <= 113
    error_message = "length of each owner should be 113 or less"
  }
}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "department" {}

data "azuread_user" "users" {
  for_each            = toset(split(",", var.owners))
  user_principal_name = each.value
}

locals {
  prefix = "a-z-mini-department"
  resource_names = {
    service_principal          = format("%s-ad-app-sp", local.prefix)
    key_vault                  = format("%s-kv", local.prefix)
    service_principal_password = format("%s-ad-app-sp-password", local.prefix)
  }
  owners = toset(concat([for user in data.azuread_user.users : user.object_id], [data.azuread_client_config.current.object_id]))
}

resource "azuread_application" "department" {
  display_name = local.resource_names.service_principal
  owners       = local.owners

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "department" {
  application_id = azuread_application.department.application_id
  use_existing   = true
  owners         = local.owners
}

resource "azuread_service_principal_password" "department" {
  service_principal_id = azuread_service_principal.department.object_id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.department.id
  principal_id         = azuread_service_principal.department.id
  role_definition_name = "Contributor"
}
