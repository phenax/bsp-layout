# amend the split type so we are arranged correctly
rotate() {
  node=$1;
  want=$2;
  have=$(jget splitType "$(bspc query -T -n "$node")");
  have=${have:1:${#have}-2};
  angle=$3;

  if [[ ! "$have" = "$want" ]]; then
    vdo bspc node "$node" -R "$3";
  fi
}

auto_balance() { bspc node "$1" -B; }
