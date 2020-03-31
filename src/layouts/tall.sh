#!/usr/bin/env bash

ROOT="/usr/lib/bsp-layout";
source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";
source "$ROOT/utils/config.sh";

master_size=$TALL_RATIO;

node_filter="!hidden";

execute_layout() {
  # ensure the count of the master child is 1, or make it so
  local win_count=$(bspc query -N '@/1' -n .descendant_of.window.$node_filter | wc -l);

  if [ $win_count -ne 1 ]; then
    local new_node="";
    if [ -z "$*" ]; then
      new_node=$(bspc query -N '@/1' -n last.descendant_of.window.$node_filter | head -n 1);
    else
      new_node=$*;
    fi

    if [ -z "$new_node" ]; then
      new_node=$(bspc query -N '@/2' -n last.descendant_of.window.$node_filter | head -n 1);
    fi

    # move everything into 2 that is not our new_node
    # for wid in $(bspc query -N '@/1' -n .descendant_of.window.$node_filter | grep -v "$new_node"); do
      # bspc node "$wid" -n '@/2';
    # done

    bspc node "$new_node" -n '@/2';
  fi

  rotate '@/' vertical 90;
  rotate '@/2' horizontal 90;

  local stack_node=$(bspc query -N '@/2' -n);
  for parent in $(bspc query -N '@/2' -n .descendant_of.!window.$node_filter | grep -v "$stack_node"); do
    rotate $parent horizontal 90;
  done

  auto_balance '@/2';

  local mon_width=$(jget width "$(bspc query -T -m)");

  local want=$(echo "$master_size * $mon_width" | bc -l | sed 's/\..*//');
  local have=$(jget width "$(bspc query -T -n '@/1')");
  bspc node "@/1.descendant_of.!window.$node_filter" --resize right $((want - have)) 0;
}

execute_layout;
