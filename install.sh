#!/usr/bin/env bash

INSTALL_DIR=/usr/lib/bsp-layout;
BINARY=/usr/local/bin/bsp-layout;
CONFIG_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/bsp-layout"; # NOTE: For the future. Not in use currently

# Clean up
rm -rf $INSTALL_DIR;
rm -rf $BINARY;

# Un install is just re-install minus the install
if [[ "$1" == "uninstall" ]]; then
  echo "Uninstalled bsp-layout";
  exit 0;
fi

TMP_DIR=$(mktemp -d /tmp/bsp-layout-install.XXXXX);

# Clone to local directory
if [[ ! "$1" == "local" ]]; then
  git clone https://github.com/phenax/bsp-layout.git $TMP_DIR/clone;
  cd $TMP_DIR/clone;
fi

# Create config if it doesn't already exist
mkdir -p "$CONFIG_DIR";
[[ -f "$CONFIG_DIR/layoutrc" ]] && cp exampleconfig "$CONFIG_DIR/layoutrc";

# Copy contents files to install directory
echo "Copying files..." &&
mkdir -p $INSTALL_DIR &&
cp -r src/* $INSTALL_DIR/ &&

# Create binary executable
echo "Creating binary..." &&
ln -s $INSTALL_DIR/layout.sh $BINARY &&

# Remove clone directory
rm -rf $TMP_DIR;

echo "Installed bsp-layout";
