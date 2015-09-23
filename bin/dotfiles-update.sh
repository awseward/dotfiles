(
  source ~/.lib/updates.sh

  # Handle args
  _FN_NAME="$1"
  if [ "" = "$_FN_NAME" ]; then
    _FN_NAME='print_usage_and_info'
  fi

  # Print info
  print_usage() {
    local function_names
    function_names="$(typeset -f | grep -E '\(\)\ $' | sed -e 's/()//g')"

    echo
    echo "Usage: dotfiles-update.sh [function_name]"
    echo
    echo "  Functions:"
    echo
    echo "$function_names" | while read line; do
      echo "    $line"
    done
    echo
  }

  print_info() {
    local last_checked
    local current_time
    local elapsed_time
    local time_to_check
    last_checked="$(read_timestamp)"
    current_time="$(date +%s)"
    elapsed_time="$((current_time - last_checked))"
    if is_time_to_check; then
      time_to_check='true'
    else
      time_to_check='false'
    fi

    echo
    echo "Dotfiles update info:"
    echo
    echo "  Timestamp file           :  $TIMESTAMP_FILEPATH"
    echo "  Update check interval    :  ${UPDATE_INTERVAL}s"
    echo "  Current time             :  $current_time"
    echo "  Last checked             :  $last_checked"
    echo "  Elapsed time             :  $elapsed_time"
    echo "  Should check for updates :  $time_to_check"
    echo
  }

  print_usage_and_info() {
    print_usage
    print_info
  }

  # Do something
  $_FN_NAME
)
