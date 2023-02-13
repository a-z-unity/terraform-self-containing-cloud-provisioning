variable "repository_id" {}
variable "pattern" {}
variable "status_check" {}
variable "dismissal_restrictions_user" {}
variable "required_approving_review_count" {}

resource "github_branch_protection" "branch_protection_rule" {
  repository_id                   = var.repository_id
  pattern                         = var.pattern
  enforce_admins                  = false
  require_signed_commits          = false
  required_linear_history         = true
  require_conversation_resolution = true
  allows_deletions                = false
  allows_force_pushes             = false

  required_status_checks {
    strict   = true
    contexts = [var.status_check]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    require_code_owner_reviews      = true
    required_approving_review_count = var.required_approving_review_count
    require_last_push_approval      = true
    dismissal_restrictions = [
      var.dismissal_restrictions_user
    ]
  }

  push_restrictions = []
}
