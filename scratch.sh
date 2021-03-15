#!/usr/bin/env bash

set -euo pipefail

readonly db_file='qwer.db'

_qwer-discover() { echo "${HOME}/.tool-versions" && qwer-discover ; }

_values() {
  while read -r filepath; do echo "(\'${filepath}\')"; done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g'
}

sqlite3 "${db_file}" <<-SQL
CREATE TABLE IF NOT EXISTS filepaths ( filepath TEXT NOT NULL UNIQUE );

CREATE VIEW IF NOT EXISTS v_filepaths AS
  SELECT
    filepaths.filepath
  , SUBSTR(
      filepath,
      0,
      INSTR(filepath, '.tool-versions')
    ) AS dirpath
  , LENGTH(
      LTRIM(filepath, '/')) - LENGTH(REPLACE(LTRIM(filepath, '/'), '/', '')
    ) AS depth
  FROM filepaths
  ;

CREATE TABLE IF NOT EXISTS packages_declared (
  filepath TEXT NOT NULL
, lang     TEXT NOT NULL
, version  TEXT NOT NULL
, UNIQUE(filepath, lang, version)
);

CREATE TABLE IF NOT EXISTS packages_latest (
  lang     TEXT NOT NULL UNIQUE
, version  TEXT
);

CREATE TABLE IF NOT EXISTS packages_installed (
  lang     TEXT NOT NULL
, version  TEXT NOT NULL
, UNIQUE(lang, version)
);

CREATE TABLE IF NOT EXISTS plugins_added (
  name TEXT NOT NULL UNIQUE
, url  TEXT NOT NULL
, ref1 TEXT NOT NULL
, ref2 TEXT NOT NULL
);

CREATE VIEW IF NOT EXISTS v_foo AS
  SELECT
    decl.*
  , decl.version = lt.version AS is_latest
  , lt.version AS latest_version
  FROM packages_declared decl
  JOIN packages_latest lt ON decl.lang = lt.lang
;

CREATE VIEW IF NOT EXISTS v_outdated AS
  SELECT filepath, lang, version, latest_version FROM v_foo
  WHERE NOT is_latest
  ;

CREATE VIEW v_install_missing AS
  SELECT
    decl.lang,
    decl.version,
    'asdf install ' || decl.lang || ' ' || decl.version as command
  FROM packages_declared decl
  WHERE   (lang, version) NOT IN (
    SELECT lang, version FROM packages_installed
  );

SQL

sqlite3 "${db_file}" <<-SQL
BEGIN;
  INSERT OR REPLACE INTO filepaths (filepath)
    VALUES $(_qwer-discover | _values);
COMMIT;
SQL

sqlite3 -readonly "${db_file}" 'SELECT DISTINCT filepath FROM v_filepaths ORDER BY 1;' \
  | while read -r filepath; do
       sort -u "${filepath}" | while read -r line; do
         # shellcheck disable=SC2207
         arr=( $(echo "${line}" | tr ' ' "\n") )
         lang="${arr[1]}"
         version="${arr[2]}"

         echo "(\'${filepath}\', \'${lang}\', \'${version}\')"
       done
    done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g' \
  | while read -r values; do
      sqlite3 "${db_file}" <<-SQL
        BEGIN;
          INSERT OR REPLACE INTO packages_declared (filepath, lang, version)
            VALUES ${values};
        COMMIT;
SQL
    done

sqlite3 -readonly "${db_file}" 'SELECT DISTINCT lang FROM packages_declared ORDER BY 1;' \
  | while read -r lang; do
      version="$(asdf latest "${lang}")"

      if [ "${version}" != '' ]; then
        echo "(\'${lang}\', \'${version}\')"
      else
        >&2 echo "Had some issue(s) resolving latest version for '${lang}'. Try \`asdf latest ${lang}\`…"
      fi
    done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g' \
  | while read -r values; do
      sqlite3 "${db_file}" <<-SQL
        BEGIN;

          -- Insert values
          INSERT INTO packages_latest (lang, version) VALUES ${values}
            ON CONFLICT(lang) DO UPDATE SET version = excluded.version;
          ;

          -- Remove langs we couldn't resolve a latest for
          DELETE FROM packages_latest WHERE TRIM(version) = '';

        COMMIT;
SQL
    done

asdf plugin list --urls --refs \
  | while read -r line; do
      # shellcheck disable=SC2086
      # shellcheck disable=SC2116
      # shellcheck disable=SC2206
      # shellcheck disable=SC2207
      cols=( $(echo $line) )
      echo "(\'${cols[1]}\', \'${cols[2]}\', \'${cols[3]}\', \'${cols[4]}\')"
    done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g' \
  | while read -r values; do
      sqlite3 "${db_file}" <<-SQL
BEGIN;

  INSERT INTO plugins_added VALUES ${values}
    ON CONFLICT(name) DO UPDATE SET
      url  = excluded.url,
      ref1 = excluded.ref1,
      ref2 = excluded.ref2
  ;

COMMIT;
SQL
    done

sqlite3 -readonly "${db_file}" 'SELECT DISTINCT name FROM plugins_added ORDER BY 1;' \
  | while read -r lang; do
  # shellcheck disable=SC2207
  arr=( $(asdf list "${lang}" 2>/dev/null ) )

  for version in "${arr[@]}"; do
    echo "(\'${lang}\', \'${version}\')"
  done
done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g' \
  | while read -r values; do
      sqlite3 "${db_file}" <<-SQL
BEGIN;

  INSERT OR REPLACE INTO packages_installed (lang, version) VALUES ${values};

COMMIT;
SQL
    done

sqlite3 -readonly "${db_file}" <<-SQL
.header on
.mode box
  SELECT * FROM v_outdated;
  SELECT * FROM v_install_missing;
SQL
