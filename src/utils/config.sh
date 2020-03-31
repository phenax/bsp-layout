CONFIG_DIR="$HOME/.config/bsp-layout";

# Default config
export TALL_RATIO=0.6;
export WIDE_RATIO=0.6;

source "$CONFIG_DIR/layoutrc" 2> /dev/null || true;
