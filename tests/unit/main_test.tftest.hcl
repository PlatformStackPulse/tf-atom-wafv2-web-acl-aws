# Unit Tests — tf-atom-wafv2-web-acl-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:  terraform test -test-directory=tests/unit
# Verbose:   terraform test -test-directory=tests/unit -verbose

mock_provider "aws" {}

# Shared inputs for every run block. Labels (namespace/stage/name) drive the
# tf-label id; scope is this module's only required input.
variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  scope          = "REGIONAL"
  default_action = "allow"
  description    = "Unit-test Web ACL"
  rules          = []
}

# ---------------------------------------------------------------------------
# Test: module creates the Web ACL when enabled (the default)
# Asserts on plan-KNOWN values only — the tf-label id, the module enabled
# flag, and the resource count. arn/id/capacity are computed under a mock
# provider (unknown at plan) so they are NOT asserted here.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing' from namespace/stage/name."
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled."
  }

  assert {
    condition     = length(aws_wafv2_web_acl.default) == 1
    error_message = "Exactly one aws_wafv2_web_acl should be planned when enabled."
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# The count-gated resource collapses to zero, and the id output falls back to
# the empty-string default from `try(...[0].id, "")`.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled."
  }

  assert {
    condition     = length(aws_wafv2_web_acl.default) == 0
    error_message = "No aws_wafv2_web_acl should be planned when disabled."
  }

  assert {
    condition     = output.id == ""
    error_message = "id output should fall back to empty string when disabled."
  }
}
