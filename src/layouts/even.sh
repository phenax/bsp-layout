#!/usr/bin/env bash

ROOT="/usr/lib/bsp-layout";
source "$ROOT/utils/layout.sh";

execute_layout() {
  auto_balance '@/';
}

execute_layout;
