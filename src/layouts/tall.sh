#!/usr/bin/env bash
# a stack layout for bspwm

master_size=.60

ROOT="$HOME/.config/bspwm";
source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";

execute_layout() {
  # ensure the count of the master child is 1, or make it so
  win_count=$(bspc query -N '@/1' -n .descendant_of.window.!hidden | wc -l)
  echo "win_count: $win_count"

  if [ $win_count -ne 1 ]; then
    if [ -z "$*" ]; then
      new_master=$(bspc query -N '@/1' -n last.descendant_of.window.!hidden | head -n 1)
    else
      new_master=$*
    fi

    if [ -z "$new_master" ]; then
      new_master=$(bspc query -N '@/2' -n last.descendant_of.window.!hidden | head -n 1)
    fi

    echo "new master: $new_master"

    # move everything into 2 that is not our new_master
    for wid in $(bspc query -N '@/1' -n .descendant_of.window.!hidden | grep -v $new_master); do
      vdo bspc node "$wid" -n '@/2'
    done

    vdo bspc node "$new_master" -n '@/1'
  fi

  vdo rotate '@/' vertical 270
  vdo rotate '@/2' horizontal 270

  stack_node=$(bspc query -N '@/2' -n)
  for parent in $(bspc query -N '@/2' -n '.descendant_of.!window.!hidden' | grep -v $stack_node); do
    vdo rotate $parent horizontal 270
  done

  auto_balance '@/2';

  mon_width=$(jget width "$(bspc query -T -m)")

  want=$(echo $master_size \* $mon_width | bc -l | sed 's/\..*//')
  have=$(jget width "$(bspc query -T -n '@/1')")
  bspc node '@/1' --resize right $((want - have)) 0
}

execute_layout;
