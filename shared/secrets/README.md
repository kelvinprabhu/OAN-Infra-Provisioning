# Secrets Management — OAN-Infra-Provisioning

## ⚠️ Golden Rule

**Secrets are NEVER stored in Git.** No passwords, tokens, API keys, or credentials
should ever appear in `.tf`, `.tfvars`, or any other tracked file.

---

## Architecture by Cloud Provider

### AWS — AWS Secrets Manager + SSM Parameter Store

Secrets are stored under the path convention:
```
oan/aws/{env}/{service}/{key}
```

Example: `oan/aws/prod/db/password`

Create secrets via CLI:
```bash
aws secretsmanager create-secret \
  --name "oan/aws/prod/db/password" \
  --secret-string "$(openssl rand -base64 32)"
```

Reference in Terraform:
```hcl
data "aws_secretsmanager_secret" "db_password" {
  name = "oan/aws/${var.environment}/db/password"
}
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.arn
}
# Usage: data.aws_secretsmanager_secret_version.db_password.secret_string
```

---

### GCP — Google Secret Manager

Path convention:
```
projects/{project_id}/secrets/oan-gcp-{env}-{service}-{key}/versions/latest
```

Create secrets via CLI:
```bash
echo -n "my-secret-value" | gcloud secrets create oan-gcp-prod-db-password \
  --replication-policy="automatic" \
  --data-file=-
```

Reference in Terraform:
```hcl
data "google_secret_manager_secret_version" "db_password" {
  secret = "oan-gcp-${var.environment}-db-password"
}
# Usage: data.google_secret_manager_secret_version.db_password.secret_data
```

---

### Azure — Azure Key Vault

Key Vault naming: `oan-{env}-kv`

Key naming: `oan-azure-{env}-{service}-{key}`

Create secrets via CLI:
```bash
az keyvault secret set \
  --vault-name "oan-prod-kv" \
  --name "oan-azure-prod-db-admin-password" \
  --value "$(openssl rand -base64 32)"
```

Reference in Terraform:
```hcl
data "azurerm_key_vault_secret" "db_password" {
  name         = "oan-azure-${var.environment}-db-admin-password"
  key_vault_id = data.azurerm_key_vault.main.id
}
# Usage: data.azurerm_key_vault_secret.db_password.value
```

---

### Self-Hosted — HashiCorp Vault

Path convention (KV v2):
```
secret/oan/self-hosted/{env}/{service}
```

Create secrets via CLI:
```bash
vault kv put secret/oan/self-hosted/prod/db \
  username="oan_admin" \
  password="$(openssl rand -base64 32)"
```

Reference in Terraform:
```hcl
data "vault_kv_secret_v2" "db" {
  mount = "secret"
  name  = "oan/self-hosted/${var.environment}/db"
}
# Usage: data.vault_kv_secret_v2.db.data["password"]
```

---

## SOPS — For Config Files with Embedded Secrets

If you need to commit encrypted config files, use [SOPS](https://github.com/getsops/sops):

```bash
# Encrypt
sops --kms arn:aws:kms:us-east-1:123456789:key/your-key-id \
  --encrypt secrets.yaml > secrets.enc.yaml

# Decrypt (in pipeline)
sops --decrypt secrets.enc.yaml > secrets.yaml
```

`.gitignore` already excludes plaintext `secrets.yaml`. Commit only `*.enc.yaml`.

---

## CI/CD — Injecting Secrets

In GitHub Actions, store secrets in GitHub Secrets and inject at runtime:

```yaml
env:
  AWS_ACCESS_KEY_ID:     ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  VAULT_TOKEN:           ${{ secrets.VAULT_TOKEN }}
```

**Never print secrets in CI logs** — use `::add-mask::` if necessary:
```yaml
- run: echo "::add-mask::${{ secrets.SOME_SECRET }}"
```
