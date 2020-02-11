#!/usr/bin/env bash

# TODO: Consider finding a better acronym here. This is roughly GitHubView, but
# that doesn't necessarily make a ton of sense
ghv() {
  local temp_dir; temp_dir="$(mktemp -d)"
  local git_sha="${1:-$(git_current_branch)}"

  cleanup() { rm -rf "${temp_dir}" >/dev/null 2>&1; }
  changed_files() { git diff --name-only "origin/master...${git_sha}"; }
  populate_local_disk() {
    changed_files | while read -r filename; do
      local ref_filename="${git_sha}:${filename}"

      git cat-file -e "${ref_filename}" 2>/dev/null && {
        local temp_filename="${temp_dir}/${filename}"

        dirname "$temp_filename" | xargs mkdir -p -

        git show "${ref_filename}" > "$temp_filename"
      }
    done
  }
  fzf_prev() {
    local preview_window

    {
      if (( $(tput cols) > 120 )); then
        preview_window="left:$(( $(tput cols) - 80 ))"
      else
        preview_window="up:$(( $(tput lines) - 10 ))"
      fi
    }

    (
      cd "${temp_dir}" \
        && fzf \
          --preview 'bat --style=numbers --color=always {}' \
          --preview-window "${preview_window}" \
          --bind 'enter:execute(vim -R -c "set nomodifiable" {})'
    )
  }

  # ---

  if [ $(changed_files | wc -l) = 0 ]; then
    return 1
  fi

  { populate_local_disk || true && fzf_prev } || true && cleanup
}
