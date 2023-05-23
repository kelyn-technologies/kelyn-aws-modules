# iam-policy

Creates IAM policy and role to enable vmimport.

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
| image_bucket_name | Name of the s3 bucket to import images into | `string` | `null` | yes |
| role_name | Name of the role once created | `string` | `vmimport` | no |

## Outputs

| Name | Description |
|------|-------------|
| image_bucket_name | The ARN assigned by AWS to this role |
