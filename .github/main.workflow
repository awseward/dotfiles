workflow "Main Workflow" {
  on = "push"
  resolves = [
    "Shellcheck",
    "Shebang Check",
  ]
}

action "Shellcheck" {
  uses = "./actions-shellcheck/"
}

action "Shebang Check" {
  uses = "./actions-shebangcheck/"
}
