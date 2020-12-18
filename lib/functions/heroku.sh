#!/usr/bin/env bash

hk_cfg_vim() {
  heroku config --shell | parallel echo 'export ' | vim -c 'set syntax=bash' -
}

hk_pg_copy_tsv() {
  local -r table_name="$1"

  psql "$(heroku config:get DATABASE_URL)" <<< "
    COPY ${table_name}
    TO STDOUT
    WITH (
      FORMAT CSV
    , DELIMITER E'\t'
    , HEADER ON
    );
  "
}
