#!/bin/bash
# V10 Demo Commands — CI/CD & Best Practices

echo "=== Show the GitHub Actions workflow ==="
cat .github/workflows/terraform.yml
# Walk through each job: validate → plan → apply

echo "=== Local workflow simulation ==="
terraform init
terraform fmt --check
terraform validate
terraform plan -out=plan.tfplan

echo "=== Show lock file ==="
cat .terraform.lock.hcl
# SHOW: provider version + checksums pinned
# SAY: "Commit this file. It ensures every runner uses the same version."

echo "=== Show the version constraint ==="
grep -A5 "required_version\|required_providers" backend.tf

echo "=== Drift detection scheduled job (concept demo) ==="
cat << 'YAML'
# Add this as a separate workflow: .github/workflows/drift-detection.yml
name: "Drift Detection"
on:
  schedule:
    - cron: '0 6 * * *'   # Every day at 6 AM UTC
jobs:
  detect-drift:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init
      - run: terraform plan -detailed-exitcode
        # Exit code 0 = no changes (no drift)
        # Exit code 2 = changes detected (drift!)
        # This step fails the job if drift is detected → Slack alert
YAML

echo ""
echo "=== TOP 10 BEST PRACTICES CHECKLIST ==="
echo "[ ] 1. Modules for every repeatable pattern"
echo "[ ] 2. Version pinning (Terraform + provider)"
echo "[ ] 3. Remote state with DynamoDB locking"
echo "[ ] 4. Secrets in env vars / secrets manager"
echo "[ ] 5. Always plan before apply"
echo "[ ] 6. One Atlas project per environment"
echo "[ ] 7. Backups + maintenance windows in code"
echo "[ ] 8. prevent_destroy on production clusters"
echo "[ ] 9. CI/CD with human approval gate"
echo "[  ] 10. Scheduled drift detection job"
echo ""
echo "How many does YOUR setup satisfy? Be honest!"
