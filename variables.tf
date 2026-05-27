# -----------------------------------------------------------------------------
# Module-Specific Variables
# -----------------------------------------------------------------------------

variable "scope" {
  type        = string
  description = "Scope of the WAF Web ACL. Valid values: REGIONAL, CLOUDFRONT."
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be REGIONAL or CLOUDFRONT."
  }
}

variable "description" {
  type        = string
  description = "Description of the Web ACL."
  default     = ""
}

variable "default_action" {
  type        = string
  description = "Default action for the Web ACL. Valid values: allow, block."
  default     = "allow"
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Default action must be allow or block."
  }
}

variable "rules" {
  type        = any
  description = "List of rule objects for the Web ACL."
  default     = []
}

variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "Whether CloudWatch metrics are enabled for the Web ACL."
  default     = true
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "Whether sampled requests are enabled."
  default     = true
}
