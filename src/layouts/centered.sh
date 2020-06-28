#!/usr/bin/env bash

source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";
source "$ROOT/utils/config.sh";

master_size=$TALL_RATIO;

node_filter="!hidden";

# AP1 - Place even on @/1 and odd on @/2. Make last @/1, root

execute_layout() {
  # for wid in $(bspc query -N '@/1' -n .descendant_of.window.$node_filter); do
    # bspc node "$wid" -n '@/2';
  # done

  # bspc node -p west && bspc node -f east && bspc node -n last.\!automatic.local

  local nodes=$(bspc query -N '@/' -n .descendant_of.window.$node_filter);
  local master=$(echo -e "$nodes" | head -n 1);
  local master="0x02800006";
  local stack=$(echo -e "$nodes" | grep -v "$master");

  bspc node "$master" -n '@/1';

  local left_master=$(echo -e "$stack" | head -n 1);
  local right_master=$(echo -e "$stack" | head -n 2 | tail -n 1);

  echo "Left: $left_master";
  echo "Right: $right_master";

  if [[ ! -z "$left_master" ]]; then
    bspc node -f "$master" && \
      bspc node -p west && \
      bspc node -f "$left_master" && \
      bspc node -n last.\!automatic.local;
    bspc node -f "$master" && bspc node -p cancel;
  fi;

  #for node in $stack; do
    #bspc node "$node" -n '@/2';
  #done;

  #local index=0;
  #for node in $(bspc query -N 'any' -n .descendant_of.window.$node_filter); do
    #echo $index;
    ##if [[ $((index % 2)) == 0 ]]; then
    #if [[ $index -lt 10 ]]; then
      #bspc node "$node" -n '@/1';
    #else
      #bspc node "$node" -n '@/2';
    #fi
    #index=$((index + 1));
  #done

  #local nodes=$(bspc query -N '@/1' -n .descendant_of.window.$node_filter);

  #local root=$(echo -e "$nodes" | tail -n 1);  # Last
  #local left=$(echo -e "$nodes" | head -n -1); # Everything but last

  #rotate $root vertical 90;
  #for node in $left; do
    #rotate $node horizontal 90;
  #done
  #for node in $(bspc query -N '@/2' -n .descendant_of.!window.$node_filter); do
    #rotate $node horizontal 90;
  #done


  # rotate '@/' vertical 90;
  # rotate '@/2' horizontal 90;

  # rotate '@/' vertical 90;

  # local stack_node=$(bspc query -N '@/2' -n);
  # for parent in $(bspc query -N '@/2' -n .descendant_of.!window.$node_filter | grep -v $stack_node); do
    # rotate $parent horizontal 90;
  # done

  # auto_balance '@/2';

  # local mon_width=$(jget width "$(bspc query -T -m)");

  # local want=$(echo "$master_size * $mon_width" | bc | sed 's/\..*//');
  # local have=$(jget width "$(bspc query -T -n '@/1')");

  # bspc node "@/1.descendant_of.window.$node_filter" --resize right $((want - have)) 0;
}

execute_layout "$@";

