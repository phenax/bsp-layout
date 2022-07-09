# The location where the states of the desktops are stored.
DESKTOP_STATE="/tmp/bsp-layout.state/desktops";

# (|Dict[str, str]|, str, str) -> Dict(str)
append_option() {
  local key=$1;
  local value=$2;
  sed "/^$key:/d"; echo "$key:$value";
}

# (|Dict[str, str]|, str) -> str
get_value_of() {
  local key=$1;
  awk -F':' "/^$key:/ {print \$2}";
}

# str -> List[str]
get_desktop_options() {
  local desktop=$1;
  cat "$DESKTOP_STATE/$desktop" 2> /dev/null || true;
}

# (str, str, str) -> ()
set_desktop_option() {
  local desktop=$1;
  local key=$2;
  local value=$3;
  new_options=$(get_desktop_options "$desktop" | append_option $key $value);
  mkdir -p "$DESKTOP_STATE";
  echo "$new_options" > "$DESKTOP_STATE/$desktop";
}

# () -> List[str]
list_desktops() {
  local desktops=$(ls -1 "$DESKTOP_STATE");
  echo -e "$desktops";
}
