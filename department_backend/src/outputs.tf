output "backend_resource_group" {
  value = azurerm_resource_group.department.name
}

output "backend_storage_account" {
  value = azurerm_storage_account.backends_storage.name
}

output "infrastructure_backend_container" {
  value = azurerm_storage_container.department_infrastructure_backend.name
}

output "backend_container" {
  value = azurerm_storage_container.department_backend.name
}

output "team_projects_backends" {
  value = [for backend in azurerm_storage_container.team_projects_backends : backend.name]
}
