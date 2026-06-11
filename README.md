# Demo Files — Session V10: CI/CD, Best Practices & Next Steps

## Purpose

GitHub Actions pipeline, S3 remote backend, version pinning, Top 10 checklist.

## File Structure

```
.github/workflows/terraform.yml
README.md
backend.tf
demo_commands.sh
main.tf
modules/atlas_env/main.tf
modules/atlas_env/outputs.tf
modules/atlas_env/variables.tf
outputs.tf
terraform.tfvars.example
variables.tf
```

## Step 1 — Create the S3 bucket for remote state

```
# Create the bucket
aws s3 mb s3://terraform-lms-v10 --region us-east-1

# Enable versioning (lets you recover a corrupted state file)
aws s3api put-bucket-versioning \
  --bucket terraform-lms-v10 \
  --versioning-configuration Status=Enabled

# Block all public access
aws s3api put-public-access-block \
  --bucket terraform-lms-v10 \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## Step 2 — Create the DynamoDB lock table

```
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

aws dynamodb describe-table \
  --table-name terraform-state-lock \
  --query "Table.TableStatus"
# Should return: "ACTIVE"
```

##

## Quick Start

```bash
# 1. Copy and fill in your credentials
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Atlas API keys and org ID

# 2. Run the demo
terraform init && terraform plan  # apply handled by GitHub Actions
```

## Prerequisites

- Terraform CLI >= 1.3 installed
- MongoDB Atlas account with an Organization
- Atlas API key with Organization Owner or Project Creator role
- API key IP access list configured in Atlas UI (your machine's IP must be listed)

## Find your credentials

- **Public/Private Key**: Atlas UI → Access Manager → API Keys → Create API Key
- **Org ID**: Atlas UI → top-left org dropdown → Organization Settings → Organization ID
- **Your IP**: `curl ifconfig.me`

## Cleanup

```bash
terraform destroy
```
