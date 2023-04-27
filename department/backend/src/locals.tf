data "azurerm_client_config" "current" {}

locals {
  prefix   = "a-z-mini-department"
  location = "West Europe"

  resource_names = {
    resource_group                              = format("%s-rg", local.prefix)
    key_vault                                   = format("%s-kv", local.prefix)
    backends_storage_account                    = replace(format("%s-sa", local.prefix), "-", "")
    department_infrastructure_backend_container = "department-infrastructure-backend"
    department_backend_container                = "department-backend"
    team_projects_backends                      = toset(split(",", var.team_projects_backends))
    service_principal                           = format("%s-ad-app-sp", local.prefix)
    devops_project                              = format("%s-pipelines", local.prefix)
  }

  contributor_emails = split(";", var.contributors)

  contributors = toset(concat(local.contributor_emails, [
    data.azurerm_client_config.current.object_id
  ]))
}
