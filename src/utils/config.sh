XDG_CONF=${XDG_CONFIG_DIR:-"$HOME/.config"};
CONFIG_DIR="$XDG_CONF/bsp-layout";

# Default config
export TALL_RATIO=0.6;
export WIDE_RATIO=0.6;

export SPAWN_BEHAVIOR=after;

source "$CONFIG_DIR/layoutrc" 2> /dev/null || true;
