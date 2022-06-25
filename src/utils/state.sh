# The location where the states of the desktops are stored.
DESKTOP_STATE="/tmp/bsp-layout.state/desktops";

# NOTE: not sure about the meaning of that signature...
# (Data ->) :: Key -> Value -> Data
append_option() {
  # Append an option to a list of options.
  #
  # Args:
  #   $1: the key of the new option.
  #   $2: the value of the new option.
  #
  # Returns:
  #   data: the new data with the option inserted.
  #
  sed "/^$1:/d"; echo "$1:$2";
}

# NOTE: not sure about the meaning of that signature...
# (Data ->) :: Key -> Data[Key]
valueof() {
  # Get the value of some data indexed by a key.
  #
  # Args:
  #   $1: the key to get the value from.
  #
  # Returns:
  #   value: the actual value indexed by the key.
  #
  awk -F':' "/^$1:/ {print \$2}";
}

# NOTE: not sure about the meaning of that signature...
# :: DesktopName -> Data
get_desktop_options() {
  # Get the current options for a given desktop.
  #
  # Args:
  #   $1: the name of the desktop.
  #
  # Returns:
  #   options: the current options set for the desktop.
  #
  cat "$DESKTOP_STATE/$1" 2> /dev/null || true;
}

# NOTE: not sure about the meaning of that signature...
# :: DesktopName -> Key -> Value -> ()
set_desktop_option() {
  # Set a new option for a desktop.
  #
  # Args:
  #   $1: the name of the desktop.
  #   $2: the key, i.e. the name of the option.
  #   $3: the value of the option to set.
  #
  # Returns:
  #   ()
  #
  new_options=$(get_desktop_options "$1" | append_option $2 $3);
  mkdir -p "$DESKTOP_STATE";
  echo "$new_options" > "$DESKTOP_STATE/$1";
}

# NOTE: not sure about the meaning of that signature...
# :: List[str]
list_desktops() {
  # Give the list of desktops bsp-layout is listening to.
  #
  # Args:
  #   ()
  #
  # Returns:
  #   desktops: the list of desktop names which are tracked by bsp-layout.
  #
  ls -1 "$DESKTOP_STATE";
}
