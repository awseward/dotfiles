(
  source ~/.lib/updates.sh

  # Handle args
  _FN_NAME="$1"
  if [ "" = "$_FN_NAME" ]; then
    _FN_NAME='print_options'
  fi

  # Print info
  print_options() {
    local function_names
    function_names="$(typeset -f | grep -E '\(\)\ $' | sed -e 's/()//g')"
    echo "Options:"

    echo "$function_names" | while read line; do
      echo "  $line"
    done
  }

  print_info() {
    local last_checked
    local current_time
    local elapsed_time
    last_checked="$(get_update_timestamp)"
    current_time="$(date +%s)"
    elapsed_time="$((current_time - last_checked))"

    echo "Timestamp file:         $UPDATES_TIMESTAMP_FILEPATH"
    echo "Update check interval:  ${UPDATE_INTERVAL}s"
    echo
    echo "Current time:           $current_time"
    echo "Last checked:           $last_checked"
    echo "Elapsed time:           $elapsed_time"
  }

  print_info_and_options() {
    print_info
    echo
    print_options
  }

  # Do something
  (
    IFS=''
    $_FN_NAME | while read line; do
      echo "  $line"
    done
  )
)
