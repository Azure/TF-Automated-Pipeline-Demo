resource "azuredevops_user_entitlement" "reviewers" {

    count = length(var.default_reviewers)

  principal_name       = var.default_reviewers[count.index]
  account_license_type = "basic"
}

resource "azuredevops_branch_policy_auto_reviewers" "example" {
  project_id = azuredevops_project.main.id

  enabled  = true
  blocking = true

  settings {
    minimum_number_of_reviewers = var.minimum_number_of_reviewers
    auto_reviewer_ids  = azuredevops_user_entitlement.reviewers.*.id
    submitter_can_vote = true    # Optional, default is false and should be, that way you can't approve your own submissions, THIS NEEDS TO BE CHANGED IN A REAL WORLD SCENARIO
    message            = "Required reviewer"

    scope {
      match_type     = "DefaultBranch"
    }
  }
}