#!/usr/bin/env bash

TMP_DIR=$(mktemp -d /tmp/bsp-layout-install.XXXXX)

## Clone to local directory
if [[ ! "$1" == "local" ]]; then
  git clone https://github.com/phenax/bsp-layout.git $TMP_DIR
  cd $TMP_DIR
fi

VERSION=$(git describe --tags --abbrev=0)

sudo make VERSION="$VERSION" install || exit 1

# Check for dependencies
for dep in bc bspc bash man; do
  !(which $dep >/dev/null 2>&1) && echo "[Missing dependency] bsp-layout needs $dep installed"
done

rm -rf "$TMP_DIR"

exit 0
