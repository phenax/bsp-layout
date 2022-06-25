#!/usr/bin/env bash

# import the lib.
source "$ROOT/utils/layout.sh";

# :: -> ::
execute_layout() {
  # Execute the even layout.
  #
  # Args:
  #   ()
  #
  # Returns:
  #   ()
  #
  auto_balance '@/';
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  *) ;;
esac;
