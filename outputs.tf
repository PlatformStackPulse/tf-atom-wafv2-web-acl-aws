output "web_acl_id" {
  description = "The ID of the WAFv2 Web ACL."
  value       = try(aws_wafv2_web_acl.this[0].id, "")
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL."
  value       = try(aws_wafv2_web_acl.this[0].arn, "")
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCU) currently being used."
  value       = try(aws_wafv2_web_acl.this[0].capacity, 0)
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}
