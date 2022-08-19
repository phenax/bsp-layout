#!/usr/bin/env bash

# import the lib.
source "$ROOT/utils/common.sh"
source "$ROOT/utils/layout.sh"
source "$ROOT/utils/config.sh"

master_size=$TALL_RATIO

node_filter="!hidden"

# List[args] -> ()
execute_layout() {
  while [[ ! "$#" == 0 ]]; do
    case "$1" in
      --master-size) master_size="$2"; shift; ;;
      *) echo "$x" ;;
    esac
    shift
  done

  # ensure the count of the master child is 1, or make it so
  local nodes=$(bspc query -N '@/1' -n .descendant_of.window.$node_filter)
  local win_count=$(echo "$nodes" | wc -l)

  if [ $win_count -ne 1 ]; then
    local new_node=$(bspc query -N '@/1' -n last.descendant_of.window.$node_filter | head -n 1)

    [ -z "$new_node" ] && new_node=$(bspc query -N '@/2' -n last.descendant_of.window.$node_filter | head -n 1)

    local root=$(echo -e "$nodes" | head -n 1)

    # move everything into 2 that is not our new_node
    for wid in $(bspc query -N '@/1' -n .descendant_of.window.$node_filter | grep -v $root); do
      bspc node "$wid" -n '@/2'
    done

    bspc node "$root" -n '@/1'
  fi

  rotate '@/' vertical 90
  rotate '@/2' horizontal 90

  local stack_node=$(bspc query -N '@/2' -n)
  for parent in $(bspc query -N '@/2' -n .descendant_of.!window.$node_filter | grep -v $stack_node); do
    rotate $parent horizontal 90
  done

  auto_balance '@/2'

  local mon_width=$(jget width "$(bspc query -T -m)")

  local want=$(( $master_size * $mon_width ))
  local have=$(jget width "$(bspc query -T -n '@/1')")

  bspc node '@/1' --resize right $((want - have)) 0
}

cmd=$1
shift
case "$cmd" in
  run) execute_layout "$@" ;;
esac

