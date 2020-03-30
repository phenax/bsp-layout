ROOT="$HOME/.config/bspwm";

DESKTOP_STATE="$ROOT/state/desktops";

# (Data ->) :: Key -> Value -> Data
append_option() { sed "/^$1:/d"; echo "$1:$2"; }

# (Data ->) :: Key -> Data[Key]
valueof() { awk -F':' "/^$1:/ {print \$2}"; }

# :: DesktopName -> Data
get_desktop_options() { cat "$DESKTOP_STATE/$1" 2> /dev/null || true; }

# :: DesktopName -> Key -> Value -> ()
set_desktop_option() {
  new_options=$(get_desktop_options "$1" | append_option $2 $3);
  mkdir -p "$DESKTOP_STATE";
  echo "$new_options" > "$DESKTOP_STATE/$1";
}

# :: List[DesktopName]
list_desktops() { ls -1 "$DESKTOP_STATE"; }

