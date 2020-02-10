#!/usr/bin/env bash

# TODO: Consider finding a better acronym here. This is roughly GitHubView, but
# that doesn't necessarily make a ton of sense
ghv() {
  local temp_dir; temp_dir="$(mktemp -d)"
  local git_sha="${1:-$(git_current_branch)}"

  do_the_thing() {
    git files "origin/master...${git_sha}" | while read -r filename; do
      local temp_filename="${temp_dir}/${filename}"
      dirname "$temp_filename" | xargs -t mkdir -p -
      git show "${git_sha}:${filename}" > "$temp_filename"
    done

    # TODO: Make this a little smarter
    ( \
      cd "${temp_dir}" \
        && fzf \
          --preview 'bat --style=numbers --color=always {}' \
          --preview-window up:50 \
    )

    # Nice for jumping from one file to another
    # vim -R -c 'set nomodifiable' -c "cd ${temp_dir}"
  }

  cleanup() { rm -rf "${temp_dir}" >/dev/null 2>&1 ; }

  do_the_thing || cleanup && cleanup
}
