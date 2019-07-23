workflow "Main Workflow" {
  on = "push"
  resolves = [
    "Shellcheck",
    "Shellmisc",
  ]
}

action "Shellcheck" {
  uses = "./actions-shellcheck/"
}

action "Shellmisc" {
  uses = "./actions-shellmisc/"
}
