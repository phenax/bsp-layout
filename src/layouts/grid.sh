#!/usr/bin/env bash
# a stack layout for bspwm

# TODO: Not complete

ROOT="$HOME/.config/bspwm";
source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";

execute_layout() {
  local nodes=$(xdo id -c);
  local node_count=$(echo "$nodes" | wc -l);
  local grid_size=$(echo "sqrt ($node_count)" | bc);

  echo "$node_count::$grid_size";

  index=1;
  for node in $nodes; do
    local mod=$(echo "$index % $grid_size" | bc);
    echo "$mod - $index";
    [[ "$mod" = $((grid_size - 1)) ]] && bspc node "$node" -R 90;
    [[ "$mod" = "0" ]] && bspc node "$node" -R 90;
    let index++;
  done

  auto_balance '@/';
}

execute_layout;
# bspc subscribe node_{remove,add} | while read _; do execute_layout; done
