# OAN-Infra-Provisioning

> Terraform-based Infrastructure Provisioning across multi-cloud and self-hosted environments.

## Project Structure

```
OAN-Infra-Provisioning/
├── aws/                        # Amazon Web Services
│   ├── dev/
│   ├── staging/
│   ├── uat/
│   ├── box/
│   └── prod/
├── gcp/                        # Google Cloud Platform
│   ├── dev/
│   ├── staging/
│   ├── uat/
│   ├── box/
│   └── prod/
├── azure/                      # Microsoft Azure
│   ├── dev/
│   ├── staging/
│   ├── uat/
│   ├── box/
│   └── prod/
├── self-hosted/                # On-Prem / Self-Hosted
│   ├── dev/
│   ├── staging/
│   ├── uat/
│   ├── box/
│   └── prod/
├── modules/                    # Reusable Terraform Modules
│   ├── aws/
│   ├── gcp/
│   ├── azure/
│   └── self-hosted/
├── shared/
│   └── secrets/                # Secrets management references
├── scripts/                    # Helper shell scripts
└── .github/workflows/          # CI/CD pipelines
```

## Environments

| Environment | Purpose                              |
|-------------|--------------------------------------|
| `dev`       | Developer sandboxes, rapid iteration |
| `box`       | Feature branch / integration testing |
| `uat`       | User Acceptance Testing              |
| `staging`   | Pre-production mirror                |
| `prod`      | Production (protected)               |

## Getting Started

### Prerequisites
- Terraform >= 1.6.x
- Cloud CLIs: `aws`, `gcloud`, `az`
- `sops` or Vault for secrets management

### Initialize an environment

```bash
cd aws/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Secrets Management

Secrets are **never committed** to Git. See `shared/secrets/README.md` for patterns.

Supported backends:
- **AWS**: AWS Secrets Manager + SSM Parameter Store
- **GCP**: Google Secret Manager
- **Azure**: Azure Key Vault
- **Self-Hosted**: HashiCorp Vault

## Conventions

- All resource names follow: `oan-{cloud}-{env}-{resource_type}-{name}`
- Tags/Labels must include: `project`, `environment`, `managed_by=terraform`, `owner`
- State files are stored remotely (never locally)
