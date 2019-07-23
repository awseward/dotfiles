workflow "New workflow" {
  on = "push"
  resolves = ["Shellcheck"]
}

action "Shellcheck" {
  uses = "./action-shellcheck/"
}
