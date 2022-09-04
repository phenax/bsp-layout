# The location where the states of the desktops are stored.
DESKTOP_STATE="/tmp/bsp-layout.state/desktops"

# Dict[key, value] | (key, value) -> Dict[key, value]
append_option() {
  local key=$1
  local value=$2
  sed "/^$key:/d"
  echo "$key:$value"
}

# Dict[key, value] | key -> value
get_value_of() {
  local key=$1
  awk -F':' "/^$key:/ {print \$2}"
}

# desktop -> List[option]
get_desktop_options() {
  local desktop=$1
  cat "$DESKTOP_STATE/$desktop" 2> /dev/null || true
}

# (desktop, key, value) -> ()
set_desktop_option() {
  local desktop=$1
  local key=$2
  local value=$3
  new_options=$(get_desktop_options "$desktop" | append_option $key $value)
  mkdir -p "$DESKTOP_STATE"
  echo "$new_options" > "$DESKTOP_STATE/$desktop"
}

# () -> List[desktop]
list_desktops() {
  local desktops=$(ls -1 "$DESKTOP_STATE")
  echo -e "$desktops"
}
