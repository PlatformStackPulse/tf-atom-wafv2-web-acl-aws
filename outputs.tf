output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "id" {
  description = "The ID of the Web ACL."
  value       = try(aws_wafv2_web_acl.default[0].id, "")
}

output "arn" {
  description = "The ARN of the Web ACL."
  value       = try(aws_wafv2_web_acl.default[0].arn, "")
}

output "capacity" {
  description = "The capacity units used by the Web ACL."
  value       = try(aws_wafv2_web_acl.default[0].capacity, 0)
}
