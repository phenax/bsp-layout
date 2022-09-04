# import the lib.
source "$ROOT/utils/common.sh"

# (node, want, angle) -> ()
rotate() {
  # Amend the split type so we are arranged correctly.
  node=$1
  want=$2
  have=$(jget splitType "$(bspc query -T -n "$node")")
  have=${have:1:${#have}-2}
  angle=$3

  [ "$have" != "$want" ] && bspc node "$node" -R "$angle"
}

# node -> ()
auto_balance() {
  # Balance the tree rooted at some node automatically.
  bspc node "$1" -B
}
