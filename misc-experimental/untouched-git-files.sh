#!/usr/bin/env sh

TMP_FILE="$(mktemp)"
ALL_FILES="$(mktemp)"
TOUCHED_FILES="$(mktemp)"

git checkout -q master
git fetch -q origin

find . -type f -not -path './.git/*' | sed -e 's/^\.\///' | sort > "$ALL_FILES"

git branch -r | sed -e 's/\s\+//g' | while read branch; do
  git checkout -q "$branch"
  git diff --name-only origin/master >> "$TMP_FILE"
done;

git checkout -q master

sort "$TMP_FILE" | uniq > "$TOUCHED_FILES"

comm -23 "$ALL_FILES" "$TOUCHED_FILES" | less -R

rm "$TMP_FILE"
rm "$ALL_FILES"
rm "$TOUCHED_FILES"
