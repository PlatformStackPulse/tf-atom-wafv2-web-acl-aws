resource "aws_wafv2_web_acl" "default" {
  count = local.enabled ? 1 : 0

  name        = module.this.id
  description = var.description
  scope       = var.scope
  tags        = module.this.tags

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      dynamic "action" {
        for_each = try(rule.value.action, null) != null ? [rule.value.action] : []
        content {
          dynamic "allow" {
            for_each = action.value == "allow" ? [1] : []
            content {}
          }
          dynamic "block" {
            for_each = action.value == "block" ? [1] : []
            content {}
          }
          dynamic "count" {
            for_each = action.value == "count" ? [1] : []
            content {}
          }
        }
      }

      dynamic "override_action" {
        for_each = try(rule.value.override_action, null) != null ? [rule.value.override_action] : []
        content {
          dynamic "none" {
            for_each = override_action.value == "none" ? [1] : []
            content {}
          }
          dynamic "count" {
            for_each = override_action.value == "count" ? [1] : []
            content {}
          }
        }
      }

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = try(rule.value.managed_rule_group, null) != null ? [rule.value.managed_rule_group] : []
          content {
            name        = managed_rule_group_statement.value.name
            vendor_name = managed_rule_group_statement.value.vendor_name
          }
        }

        dynamic "rule_group_reference_statement" {
          for_each = try(rule.value.rule_group_arn, null) != null ? [rule.value.rule_group_arn] : []
          content {
            arn = rule_group_reference_statement.value
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = try(rule.value.ip_set_arn, null) != null ? [rule.value.ip_set_arn] : []
          content {
            arn = ip_set_reference_statement.value
          }
        }

        dynamic "rate_based_statement" {
          for_each = try(rule.value.rate_limit, null) != null ? [rule.value.rate_limit] : []
          content {
            limit              = rate_based_statement.value
            aggregate_key_type = "IP"
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = try(rule.value.cloudwatch_metrics_enabled, true)
        metric_name                = rule.value.name
        sampled_requests_enabled   = try(rule.value.sampled_requests_enabled, true)
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = module.this.id
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
}
