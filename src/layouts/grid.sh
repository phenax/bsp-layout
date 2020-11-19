#!/usr/bin/env bash

source "$ROOT/utils/layout.sh";

setup_layout() {
  local direction="horizontal";

  while [[ ! "$#" == 0 ]]; do
    case "$1" in
      --direction) direction="$2"; shift; ;;
      *) ;;
    esac;
    shift;
  done;

  case $direction in
    vertical)
      rotate '@/' vertical 90;
      rotate '@/2' horizontal 90;
    ;;
    *)
      rotate '@/' horizontal 90;
      rotate '@/2' vertical 90;
    ;;
  esac;
}

execute_layout() {
  local target='first';

  for node in $(bspc query -N -n .local.window | sort); do
    bspc node $node -n "$(bspc query -N -n @/${target})";
    [[ "$target" == 'first' ]] && target='second' || target='first';
  done;

  auto_balance '@/';
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  setup) setup_layout "$@" ;;
  *) ;;
esac;
