#!/usr/bin/env bash

source "$ROOT/utils/layout.sh";

execute_layout() {
  target=first;

  for node in $(bspc query -N -n .local.window | sort); do
    bspc node $node -n "$(bspc query -N -n @$(bspc query -D -d):/${target})";
    [[ "$target" = "first" ]] && target="second" || target="first";
  done;

  auto_balance '@/';
}

execute_layout "$@";
