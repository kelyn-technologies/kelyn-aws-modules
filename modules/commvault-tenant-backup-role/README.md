# commvault-tenant-backup-role

Creates IAM policy and role to enable commvault backups. Allows

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| provider_aws" | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| central_arn | ARN of the role on the central commvault account | `string` | `null` | yes |
| role_name | Name of the role once created | `string` | `commvault_backup_role` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_role_cv_backup_arn | The ARN assigned by AWS to this role |
