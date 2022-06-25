#!/usr/bin/env bash

# import the lib.
source "$ROOT/utils/layout.sh";

# :: -> ::
setup_layout() {
  # Setup the rgrid layout.
  #
  # Args:
  #   ()
  #
  # Returns:
  #   ()
  #
  rotate '@/' vertical 90;
  rotate '@/2' horizontal 90;
}

# List[str] -> ::
execute_layout() {
  # Execute the rgrid layout.
  #
  # Args:
  #   $@: the list of all the arguments for the layout.
  #
  # Returns:
  #   ()
  #
  bash "$ROOT/layouts/grid.sh" run $*;
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  setup) setup_layout "$@" ;;
  *) ;;
esac;
