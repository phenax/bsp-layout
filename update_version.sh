#! /usr/bin/env bash

update_string="Updating version for";

if [[ "$1" == *bsp-layout.1 ]]; then
  echo "$update_string manpage"
  sed "s|{{VERSION}}|$(git describe --tags --abbrev=0)|g" bsp-layout.1 > "$1"
else
  echo "$update_string main script"
  sed "s|{{VERSION}}|$(git describe --tags --abbrev=0)|g" layout.sh.tmp > "$1"/layout.sh
fi
