data "aws_iam_policy_document" "cv_backup" {
  statement {
    sid = "DeleteVolumeSnapshot"

    actions = [
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/_GX_BACKUP_"

      values = ["*"]
    }
  }

  statement {
    sid = "DeleteEc2Tags"

    actions = ["ec2:DeleteTags"]

    resources = ["*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:TagKeys"

      values = [
        "CV_Retain_Snap",
        "CV_Integrity_Snap",
        "_GX_BACKUP_",
        "_GX_AMI_",
        "Name",
        "Description"
      ]
    }
  }

  statement {
    sid = "DetachEc2GXBackup"

    actions = ["ec2:DetachVolume"]

    resources = ["arn:*:ec2:*:*:volume/*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/_GX_BACKUP_"

      values = ["*"]
    }
  }

  statement {
    sid = "TerminateCVIntegritySnap"

    actions = ["ec2:TerminateInstances"]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CV_Integrity_Snap"

      values = ["*"]
    }
  }

  statement {
    sid = "TerminateGXBackup"

    actions = ["ec2:TerminateInstances"]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/_GX_BACKUP_"

      values = ["*"]
    }
  }

  statement {
    sid = "DetachInstanceVolumes"

    actions = ["ec2:DetachVolume"]

    resources = ["arn:*:ec2:*:*:instance/*"]
  }

  statement {
    sid = "BackupPermissions"

    actions = [
      "ebs:CompleteSnapshot",
      "ebs:GetSnapshotBlock",
      "ebs:PutSnapshotBlock",
      "ebs:StartSnapshot",
      "ebs:ListChangedBlocks",
      "ebs:ListSnapshotBlocks",
      "ec2:CopySnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeVolumesModifications",
      "ec2:CreateImage",
      "ec2:DescribeSnapshots",
      "ec2:ModifySnapshotAttribute",
      "ec2:ModifyImageAttribute",
      "ec2:StartInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeAccountAttributes",
      "ec2:ImportImage",
      "ec2:CancelImportTask",
      "ec2:DescribeKeyPairs",
      "ec2:ModifyVolume",
      "ec2:CreateTags",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:DeleteNetworkInterface",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:DescribeVolumeAttribute",
      "ec2:CreateVolume",
      "ec2:CreateNetworkInterface",
      "ec2:DisassociateIamInstanceProfile",
      "ec2:DescribeSubnets",
      "ec2:AttachVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeRegions",
      "ec2:GetConsoleOutput",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeAvailabilityZones",
      "ec2:CreateSnapshot",
      "ec2:DescribeInstanceStatus",
      "ec2:DetachNetworkInterface",
      "ec2:DescribeIamInstanceProfileAssociations",
      "ec2:DescribeTags",
      "ec2:ModifyInstanceAttribute",
      "ec2:DescribeImportImageTasks",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeImages",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcEndpoints",
      "ec2:GetEbsEncryptionByDefault",
      "ec2:GetEbsDefaultKmsKeyId",
      "ec2:AssociateIamInstanceProfile",
      "ec2:AttachNetworkInterface",
      "ec2:RegisterImage",
      "iam:GetAccountAuthorizationDetails",
      "iam:GetRole",
      "iam:ListRoles",
      "iam:ListInstanceProfiles",
      "iam:GetInstanceProfile",
      "iam:SimulatePrincipalPolicy",
      "iam:PassRole",
      "iam:GetUser",
      "kms:Decrypt",
      "kms:ListResourceTags",
      "kms:TagResource",
      "kms:CreateKey",
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateDataKeyPairWithoutPlaintext",
      "kms:GenerateDataKeyPair",
      "kms:Encrypt",
      "kms:ListGrants",
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:CreateAlias",
      "s3:CreateBucket",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketAcl",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "ssm:CancelCommand",
      "ssm:SendCommand",
      "ssm:ListCommands",
      "ssm:ListDocuments",
      "ssm:DescribeDocument",
      "ssm:DescribeInstanceInformation"
    ]

    resources = ["*"]
  }

  statement {
    sid = "IamPassRole"

    actions = ["iam:PassRole"]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "cv_backup" {
  name        = "${var.role_name}-policy"
  description = "Policy for ${var.role_name}"
  policy      = data.aws_iam_policy_document.cv_backup.json
}

resource "aws_iam_role" "cv_backup" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.central_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cv_backup" {
  policy_arn = aws_iam_policy.cv_backup.arn
  role       = aws_iam_role.cv_backup.name
}
