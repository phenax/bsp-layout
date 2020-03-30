#!/bin/bash

ROOT="/usr/lib/bsp-layout";
source "$ROOT/utils/desktop.sh";
source "$ROOT/utils/state.sh";

LAYOUTS="$ROOT/layouts";

# Kill old layout process
kill_layout() {
  old_pid="$(get_desktop_options "$1" | valueof pid)";
  kill $old_pid 2> /dev/null || true;
}

remove_listener() {
  desktop=$1;
  [[ -z "$desktop" ]] && desktop=$(get_focused_desktop);

  kill_layout "$desktop";

  # Reset process id and layout
  set_desktop_option $desktop 'layout' "";
  set_desktop_option $desktop 'pid'    "";
}

start_listener() {
  layout=$1;
  selected_desktop=$2;
  layout_file="$LAYOUTS/$layout.sh";

  # Default layout removes any other listener
  [[ "$layout" == "default" ]] && remove_listener "$selected_desktop" && exit 0;

  # Check if layout exists
  [[ ! -f $layout_file ]] && echo "Layout does not exist" && exit 1;

  # Set selected desktop to currently focused desktop if option is not specified
  [[ -z "$selected_desktop" ]] && selected_desktop=$(get_focused_desktop);

  recalculate_layout() { bash -c "$layout_file"; }

  # Recalculate styles as soon as they are set
  [[ "$(get_focused_desktop)" = "$selected_desktop" ]] && recalculate_layout;

  # Then listen to node additions and recalculate as required
  bspc subscribe node_{add,remove} | while read line; do
    desktop_id=$(echo "$line" | awk '{print $3}');
    desktop_name=$(get_desktop_name_from_id "$desktop_id");

    [[ "$desktop_name" = "$selected_desktop" ]] && recalculate_layout;
  done &

  LAYOUT_PID=$!; # PID of the listener in the background
  disown;

  # Kill old layout
  kill_layout $selected_desktop;

  # Set current layout
  set_desktop_option $selected_desktop 'layout' "$layout";
  set_desktop_option $selected_desktop 'pid'    "$LAYOUT_PID";

  echo "[$LAYOUT_PID]";
}

reload_layouts() {
  list_desktops | while read desktop; do
    layout=$(get_desktop_options "$desktop" | valueof layout);
    [[ ! -z "$layout" ]] && start_listener $layout $desktop;
  done;
}

action=$1; shift;

case "$action" in
  reload)     reload_layouts ;;
  once)       $LAYOUTS/$1 ;;
  set)        start_listener "$@" ;;
  get)        get_desktop_options "$1" ;;
  remove)     remove_listener "$1" ;;
  layouts)    echo "default"; ls "$LAYOUTS" | sed -e 's/\.sh$//'; ;;
  reset-all)
    ps aux | \
      grep "bspc subscribe" | \
      grep -v grep | \
      awk '{print $2}' | \
      xargs kill;
  ;;
  *) echo "Usage: layout.sh [set <layout> <desktop-name>|get <desktop-name>|remove]" ;;
esac
