(
  source ~/.lib/updates.sh

  # Handle args
  _FN_NAME="$1"
  if [ "" = "$_FN_NAME" ]; then
    _FN_NAME='print_usage'
  fi

  # Print info
  print_usage() {
    local function_names
    function_names="$(typeset -f | grep -E '\(\)\ $' | sed -e 's/()//g')"
    echo "Usage: dotfiles-update.sh [function_name]"
    echo "  Functions:"
    echo "$function_names" | while read line; do
      echo "    $line"
    done
  }

  print_info() {
    local last_checked
    local current_time
    local elapsed_time
    last_checked="$(read_timestamp)"
    current_time="$(date +%s)"
    elapsed_time="$((current_time - last_checked))"

    echo "Timestamp file        :  $TIMESTAMP_FILEPATH"
    echo "Update check interval :  ${UPDATE_INTERVAL}s"
    echo "Current time          :  $current_time"
    echo "Last checked          :  $last_checked"
    echo "Elapsed time          :  $elapsed_time"
  }

  print_info_and_usage() {
    print_info
    echo
    print_usage
  }

  # Do something
  $_FN_NAME
)
