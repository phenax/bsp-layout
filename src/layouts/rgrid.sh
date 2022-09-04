#!/usr/bin/env bash

# import the lib.
source "$ROOT/utils/layout.sh"

# () -> ()
setup_layout() {
  rotate '@/' vertical 90
  rotate '@/2' horizontal 90
}

# List[args] -> ()
execute_layout() {
  bash "$ROOT/layouts/grid.sh" run $*
}

cmd=$1
shift
case "$cmd" in
  run) execute_layout "$@" ;;
  setup) setup_layout "$@" ;;
esac
