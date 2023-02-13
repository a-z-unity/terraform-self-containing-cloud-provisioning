data "github_user" "owner" {
  username = "a-z-hub"
}

data "github_branch" "main" {
  repository = github_repository.department_ioc.name
  branch     = "main"
}

data "azuread_user" "users" {
  for_each            = toset(split(",", var.contributors))
  user_principal_name = each.value
}

resource "azurerm_resource_group" "department" {
  name     = local.resource_names.resource_group
  location = local.location
}

resource "azurerm_key_vault" "department" {
  name                        = local.resource_names.key_vault
  location                    = azurerm_resource_group.department.location
  resource_group_name         = azurerm_resource_group.department.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "department_sp" {
  key_vault_id = azurerm_key_vault.department.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  secret_permissions = [
    "Get", "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "department_contributors" {
  for_each = data.azuread_user.users

  key_vault_id = azurerm_key_vault.department.id
  object_id    = each.value.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  secret_permissions = [
    "Get", "List"
  ]
}

resource "azurerm_storage_account" "backends_storage" {
  name                     = local.resource_names.backends_storage_account
  resource_group_name      = azurerm_resource_group.department.name
  location                 = azurerm_resource_group.department.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "department_infrastructure_backend" {
  name                  = local.resource_names.department_infrastructure_backend_container
  storage_account_name  = azurerm_storage_account.backends_storage.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "department_backend" {
  name                  = local.resource_names.department_backend_container
  storage_account_name  = azurerm_storage_account.backends_storage.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "team_projects_backends" {
  for_each              = local.resource_names.team_projects_backends
  name                  = each.value
  storage_account_name  = azurerm_storage_account.backends_storage.name
  container_access_type = "blob"
}

resource "github_repository" "department_ioc" {
  name                   = "terraform-self-containing-cloud-provisioning"
  description            = "IoC example"
  visibility             = "public"
  auto_init              = true
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  allow_merge_commit     = false
  allow_rebase_merge     = true
  allow_squash_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
  is_template            = false
  has_downloads          = false
  gitignore_template     = "Terraform"
  license_template       = ""
  archived               = false
  archive_on_destroy     = true
  vulnerability_alerts   = true
}

resource "github_branch" "dev" {
  repository    = github_repository.department_ioc.name
  branch        = "dev"
  source_branch = data.github_branch.main.branch
}

resource "github_branch_default" "default" {
  repository = github_repository.department_ioc.name
  branch     = github_branch.dev.branch
}

module "github_branch_protection_rules" {
  for_each = toset([
    data.github_branch.main.branch, github_branch.dev.branch
  ])
  source                          = "../../modules/github_branch_protection_rule"
  repository_id                   = github_repository.department_ioc.name
  pattern                         = each.value
  status_check                    = "ci.yml"
  dismissal_restrictions_user     = data.github_user.owner.node_id
  required_approving_review_count = 1
}
