# import the lib.
source "$ROOT/utils/config.sh";

names="--names"
[[ $USE_NAMES -eq 0 ]] && names="";

# :: -> str
get_focused_desktop() {
  # Get the name of the focused desktop.
  #
  # Args:
  #   ()
  #
  # Returns:
  #   desktop: the name of the focused desktop.
  #
    bspc query -D -d 'focused' $names;
}

# int -> str
get_desktop_name_from_id() {
  # Get the name of the desktop whose ID is the one given as argument.
  #
  # Args:
  #   $1: the id of the desktop.
  #
  # Returns:
  #   desktop_name: the name of the desktop.
    bspc query -D -d "$1" $names;
}
