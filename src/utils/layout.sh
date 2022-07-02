# import the lib.
source "$ROOT/utils/common.sh";

# (str, str, int) ->
rotate() {
  # Amend the split type so we are arranged correctly.
  node=$1;
  want=$2;
  have=$(jget splitType "$(bspc query -T -n "$node")");
  have=${have:1:${#have}-2};
  angle=$3;

  if [[ "$have" != "$want" ]]; then
    bspc node "$node" -R "$angle";
  fi
}

# str ->
auto_balance() {
  # Balance the tree rooted at some node automatically.
  local node=$1;
  bspc node "$node" -B;
}
