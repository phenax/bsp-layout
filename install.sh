#!/usr/bin/env bash

INSTALL_DIR=/usr/lib/bsp-layout;
BINARY=/usr/local/bin/bsp-layout;
CONFIG_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/bsp-layout"; # NOTE: For the future. Not in use currently

# Clean up
rm -rf $INSTALL_DIR;
rm -rf $BINARY;

if [[ "$1" == "uninstall" ]]; then
  echo "Uninstalled bsp-layout";
  exit 0;
fi

# Copy contents files to install directory
echo "Copying files..." &&
mkdir -p $INSTALL_DIR &&
cp -r src/* $INSTALL_DIR/ &&
chmod +x src/layout.sh &&
chmod +x src/layouts/*.sh &&

# Create binary executable
echo "Creating binary..." &&
ln -s $INSTALL_DIR/layout.sh $BINARY &&

echo "Installed bsp-layout";

