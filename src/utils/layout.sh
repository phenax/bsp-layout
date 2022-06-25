# import the lib.
source "$ROOT/utils/common.sh";

# (str, str, int) -> ::
rotate() {
  # Amend the split type so we are arranged correctly
  #
  # Args:
  #   $1: the node to apply the rotation to.
  #   $2: the orientation that we want.
  #   $3: the angle of rotation.
  #
  # Returns:
  #   ()
  #
  node=$1;
  want=$2;
  have=$(jget splitType "$(bspc query -T -n "$node")");
  have=${have:1:${#have}-2};
  angle=$3;

  if [[ "$have" != "$want" ]]; then
    bspc node "$node" -R "$angle";
  fi
}

# str -> ::
auto_balance() {
  # Balance the tree rooted at some node automatically.
  #
  # Args:
  #   $1: the root node to balance the tree.
  #
  # Returns:
  #   ()
  #
  bspc node "$1" -B;
}
