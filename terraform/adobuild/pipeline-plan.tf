resource "azuredevops_build_definition" "plan" {

count = length(var.environments)

  project_id = azuredevops_project.main.id
  name       = "plan"
  path       = "\\${var.application_name}\\${var.environments[count.index]}"

  ci_trigger {
    use_yaml = false
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.tfrepo.id
    branch_name = azuredevops_git_repository.tfrepo.default_branch
    yml_path    = ".azdo-pipelines/terraform-plan.yaml"
  }

  variable_groups = [ var.environments[count.index] == "dev" ? azuredevops_variable_group.dev_secrets.id : azuredevops_variable_group.prod_secrets.id ]

  variable {
    name  = "ApplicationName"
    value = var.application_name
  }

  variable {
    name  = "EnvironmentName"
    value = var.environments[count.index]
  }
  variable {
    name = "WorkingDirectory"
    value = "terraform"
  }
}