#!/usr/bin/env bash

VERSION="0.0.3";

INSTALL_DIR=/usr/lib/bsp-layout;
BINARY=/usr/local/bin/bsp-layout;
MAN_PAGE=/usr/local/man/man1/bsp-layout.1;

# Clean up
rm -rf $INSTALL_DIR;
rm -rf $BINARY;
rm -rf $MAN_PAGE;

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

inject_version() {
  sed "s/{{VERSION}}/$VERSION/g" < $1 > $2;
}

# Copy contents files to install directory
echo "Copying files..." &&
mkdir -p $INSTALL_DIR &&
cp -r src/* $INSTALL_DIR/ &&
inject_version "src/layout.sh" "$INSTALL_DIR/layout.sh" && # Replace version number
chmod +x $INSTALL_DIR/layouts/*.sh &&
chmod +x $INSTALL_DIR/layout.sh &&

# Install manpage
inject_version "bsp-layout.1" "$MAN_PAGE" &&

# Create binary executable
echo "Creating binary..." &&
ln -s $INSTALL_DIR/layout.sh $BINARY &&

# Remove clone directory
rm -rf $TMP_DIR &&

echo "Installed bsp-layout";

# Check for dependencies
for dep in bc bspc; do
  !(which $dep >/dev/null 2>&1) && echo "[Missing dependency] bsp-layout needs $dep installed";
done;

exit 0;
