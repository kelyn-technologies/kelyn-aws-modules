# Kelyn Technologies Commvault Identity and Access Management (IAM) Terraform module

Terraform modules for use in creating required IAM resources for commvault.

# Features

1. Create a CV Backup Role in your account to support all necessary [CV actions](https://documentation.commvault.com/v11/essential/120910_creating_aws_role_with_restricted_access.html)
2. Create a VMImport Role in your account to support [VM Conversion](https://documentation.commvault.com/v11/essential/108828_creating_vmimport_role.html)

# Usage:

1. `commvault_tenant_backup_role`
    ```terraform
    module "cv_backup_role" {
      source = "kelyn-technologies/terraform-aws-commvault-iam//modules/commvault-tenant-backup-role"

      providers = {
        aws = aws.provider_alias
      }

      role_name   = "custom_role_name"
      central_arn = "arn:aws:iam::123456789012:role/central_role_name"
    }

    # Output the arn of the backup role using the child output
    output "backup_role_arn" {
        value = module.cv_backup_role.iam_role_cv_backup_arn
    }
    ```

2. `aws_vmimport_role`

    ```terraform
    module "vmimport_role" {
      source = "kelyn-technologies/terraform-aws-commvault-iam//modules/aws-vmimport-role"

      providers = {
        aws = aws.provider_alias
      }

      image_bucket_name = "custom_bucket_name"
      role_name         = "custom_role_name" # Default vmimport
    }
    ```

