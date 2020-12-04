#!/usr/bin/env bash

TMP_DIR=$(mktemp -d /tmp/bsp-layout-install.XXXXX);

## Clone to local directory
if [[ ! "$1" == "local" ]]; then
  git clone https://github.com/phenax/bsp-layout.git $TMP_DIR/clone;
  cd $TMP_DIR/clone;
fi

make install;

rm -rf $TMP_DIR;

