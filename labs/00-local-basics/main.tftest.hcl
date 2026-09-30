run "valid_project" {
  command = plan

  variables {
    project = "demo"
  }

  assert {
    condition     = output.names[0] == "demo-network"
    error_message = "The first generated name must use the project prefix."
  }

  assert {
    condition     = output.name_map["demo-compute"] == "DEMO-COMPUTE"
    error_message = "The generated map should contain normalized names."
  }
}
