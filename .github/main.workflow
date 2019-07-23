workflow "Main Workflow" {
  on = "push"
  resolves = ["Shellcheck"]
}

action "Shellcheck" {
  uses = "./actions-shellcheck/"
}
