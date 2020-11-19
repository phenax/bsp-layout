#!/usr/bin/env bash

source "$ROOT/utils/layout.sh";

execute_layout() {
  auto_balance '@/';
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  *) ;;
esac;
