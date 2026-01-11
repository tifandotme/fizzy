# Fizzy

This repo is my personal fork of github.com/basecamp/fizzy.

## What is Fizzy?

Fizzy is a collaborative project management and issue tracking application built by 37signals/Basecamp. It's a kanban-style tool for teams to create and manage cards (tasks/issues) across boards, organize work into columns representing workflow stages, and collaborate via comments, mentions, and assignments.

## Custom Configuration

This fork includes infrastructure and deployment tooling:

Files added:

- .github/workflows/\* (CI/CD pipeline)
- .github/actions/\* (Infrastructure setup)
- .env (Encrypted by dotenvx)
- mise.toml (Development environment setup)
- .terraform/ (Infrastructure as code)
- .kamal/ (Deployment configuration)

Files modified:

- config/deploy.yml (Kamal deployment config)

## Agent Instructions

Before each conversation, ensure you have read the custom configuration files listed above if not already provided as context.

### Terraform

Do not run `terraform apply` or `terraform destroy` without explicit user permission. You may run `terraform plan` to preview changes.

After modifying Terraform files, run validation and formatting:

```
terraform -chdir=terraform validate
terraform -chdir=terraform fmt
```

### Kamal

Before working in the .kamal/ directory, run `kamal docs` and consult the relevant command documentation (e.g., `kamal docs proxy`).
