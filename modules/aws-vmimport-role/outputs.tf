output "iam_role_vmimport_arn" {
  description = "The ARN of the vmimport role"
  value       = aws_iam_role.vmimport.arn
}
