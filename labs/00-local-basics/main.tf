locals {
  names = [
    "${var.project}-network",
    "${var.project}-compute",
    "${var.project}-observability"
  ]

  by_name = {
    for name in local.names : name => upper(name)
  }
}

check "valid_project_name" {
  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "project must contain lowercase letters, numbers, and hyphens only."
  }
}
