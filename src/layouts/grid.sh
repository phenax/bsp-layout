#!/usr/bin/env bash

# import the lib.
source "$ROOT/utils/layout.sh"

# () -> ()
setup_layout() {
  rotate '@/' horizontal 90
  rotate '@/2' vertical 90
}

# () -> ()
execute_layout() {
  local target='first'

  for node in $(bspc query -N -n .local.window | sort); do
    bspc node $node -n "$(bspc query -N -n @/${target})"
    [ "$target" = "first" ] && target='second' || target='first'
  done

  auto_balance '@/'
}

cmd=$1
shift
case "$cmd" in
  run) execute_layout "$@" ;;
  setup) setup_layout "$@" ;;
esac
