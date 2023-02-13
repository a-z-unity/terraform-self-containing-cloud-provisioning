variable "team_projects_backends" {
  type    = string

  validation {
    condition = alltrue([
      for name in split(",", var.team_projects_backends) :
      (length(name) >= 3 && length(name) <= 63)
    ])
    error_message = "'team_projects_backends' each value must be between 3 and 63 characters"
  }

  validation {
    condition = alltrue([
      for name in split(",", var.team_projects_backends) :
      (can(regex("^[a-z0-9]+[a-z0-9\\-]+$", name)))
    ])
    error_message = "'team_projects_backends' contains invalid characters"
  }
}

variable "contributors" {
  type = string

  validation {
    condition     = length(var.contributors) > 0
    error_message = "'contributors' should contains 1 or more values"
  }
}
