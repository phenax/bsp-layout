# this module extracts the user config.

# get the name of the config file.
XDG_CONF=${XDG_CONFIG_DIR:-"$HOME/.config"}
CONFIG_DIR="$XDG_CONF/bsp-layout"

# Default config.
export TALL_RATIO=0.6
export WIDE_RATIO=0.6
export USE_NAMES=1

# extract the actual user config.
source "$CONFIG_DIR/layoutrc" 2> /dev/null || true
