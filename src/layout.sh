#!/usr/bin/env bash

export VERSION="{{VERSION}}";
export ROOT="{{SOURCE_PATH}}";

source "$ROOT/utils/desktop.sh";
source "$ROOT/utils/layout.sh";
source "$ROOT/utils/state.sh";

export LAYOUTS="$ROOT/layouts";

# Layouts provided by bsp out of the box
BSP_DEFAULT_LAYOUTS="tiled\nmonocle";

# Kill old layout process
kill_layout() {
  local old_pid=$1;
  kill $old_pid 2> /dev/null || true;
}

remove_listener() {
  desktop=$1;
  [[ -z "$desktop" ]] && desktop=$(get_focused_desktop);

  local old_pid="$(get_desktop_options "$desktop" | valueof pid)";

  # Reset process id and layout
  set_desktop_option $desktop 'layout' "";
  set_desktop_option $desktop 'pid'    "";
  set_desktop_option $desktop 'did'    "";

  kill_layout $old_pid;
}

get_layout_file() {
  local layout_file="$LAYOUTS/$1.sh"; shift;
  # GUARD: Check if layout exists
  [[ ! -f $layout_file ]] && echo "Layout [$layout_file] does not exist" && exit 1;
  echo "$layout_file";
}

setup_layout() { bash "$(get_layout_file $1)" setup $*; }
run_layout() {
  local old_scheme=$(bspc config automatic_scheme);
  bspc config automatic_scheme alternate;
  bash "$(get_layout_file $1)" run $*;
  bspc config automatic_scheme $old_scheme;
}

get_layout() {
  # Set desktop to currently focused desktop if option is not specified
  local desktop="${1:-`get_focused_desktop`}";

  local layout=$(get_desktop_options "$desktop" | valueof layout);
  echo "${layout:-"-"}";
}

list_layouts() {
  echo -e "$BSP_DEFAULT_LAYOUTS"; ls "$LAYOUTS" | sed -e 's/\.sh$//';
}

previous_layout() {
  local layouts=$(list_layouts);
  local desktop_selector=$(get_focused_desktop);
  while [[ $# != 0 ]]; do
    case $1 in
      --layouts)
          if [[ ! -z "$2" ]]; then
            layouts=$(echo "$2" | tr ',' '\n');
          fi;
          shift;
      ;;
      --desktop)
        desktop_selector="$2";
        shift;
      ;;
      *) ;;
    esac;
    shift;
  done;

  local current_layout=$(get_layout "$desktop_selector");
  local previous_layout=$(echo -e "$layouts" | grep -x "$current_layout" -B 1 | head -n 1);
  if [[ "$previous_layout" == "$current_layout" ]] || [[ -z "$previous_layout" ]]; then
    previous_layout=$(echo -e "$layouts" | head -n 1);
  fi;

  echo "$current_layout:$previous_layout";
  start_listener "$previous_layout" "$desktop_selector";
}

next_layout() {
  local layouts=$(list_layouts);
  local desktop_selector=$(get_focused_desktop);
  while [[ $# != 0 ]]; do
    case $1 in
      --layouts)
          if [[ ! -z "$2" ]]; then
            layouts=$(echo "$2" | tr ',' '\n');
          fi;
          shift;
      ;;
      --desktop)
        desktop_selector="$2";
        shift;
      ;;
      *) ;;
    esac;
    shift;
  done;

  local current_layout=$(get_layout "$desktop_selector");
  local next_layout=$(echo -e "$layouts" | grep -x "$current_layout" -A 1 | tail -n 1);
  if [[ "$next_layout" == "$current_layout" ]] || [[ -z "$next_layout" ]]; then
    next_layout=$(echo -e "$layouts" | head -n 1);
  fi;

  echo "$current_layout:$next_layout";
  start_listener "$next_layout" "$desktop_selector";
}

start_listener() {
  layout=$1; shift;
  selected_desktop=$1; shift;
  [[ "$selected_desktop" == "--" ]] && selected_desktop="";

  args=$@;

  # Set selected desktop to currently focused desktop if option is not specified
  [[ -z "$selected_desktop" ]] && selected_desktop=$(get_focused_desktop);

  bspc desktop "$selected_desktop" -l tiled;

  # If it is a bsp default layout, set that
  if (echo -e "$BSP_DEFAULT_LAYOUTS" | grep "^$layout$"); then
    remove_listener "$selected_desktop";
    set_desktop_option $selected_desktop 'layout' "$layout";
    bspc desktop "$selected_desktop" -l "$layout";
    bspc node @/ -E;
    exit 0;
  fi

  __initialize_layout() { setup_layout $layout $args 2> /dev/null || true; }
  __recalculate_layout() { run_layout $layout $args 2> /dev/null || true; }

  # Then listen to node changes and recalculate as required
  bspc subscribe node_{add,remove,transfer,flag,state} desktop_focus desktop_remove | while read line; do
    event=$(echo "$line" | awk '{print $1}');
    arg_index=$([[ "$event" == "node_transfer" ]] && echo "6" || echo "3");
    desktop_id=$(echo "$line" | awk "{print \$$arg_index}");
    desktop_name=$(get_desktop_name_from_id "$desktop_id");

    if [[ "$event" == "desktop_remove" ]]; then
      selected_desktop_id=$(get_desktop_options "$selected_desktop" | valueof did);
      if [[ "$desktop_id" == "$selected_desktop_id" ]]; then
        remove_listener "$selected_desktop";
        exit 0;
      fi
    fi

    if [[ "$desktop_name" == "$selected_desktop" ]]; then
      __initialize_layout;

      if [[ "$event" == "node_transfer" ]]; then
        local source=$(echo "$line" | awk '{print $3}');
        local dest=$(echo "$line" | awk '{print $6}');

        [[ "$source" != "$dest" ]] && __recalculate_layout;
      else
        __recalculate_layout;
      fi;
    fi;
  done &

  LAYOUT_PID=$!; # PID of the listener in the background
  disown;

  # Kill old layout
  local old_pid="$(get_desktop_options "$selected_desktop" | valueof pid)";
  kill_layout $old_pid;

  desktop_id=$(bspc query -D -d "$selected_desktop");
  # Set current layout
  set_desktop_option $selected_desktop 'layout' "$layout";
  set_desktop_option $selected_desktop 'pid'    "$LAYOUT_PID";
  set_desktop_option $selected_desktop 'did'    "$desktop_id";

  # Recalculate styles as soon as they are set if it is on the selected desktop
  if [[ "$(get_focused_desktop)" == "$selected_desktop" ]]; then
    # Setup
    __initialize_layout;

    # Calculate layout twice to ensure rotations are corrected from previous layout
    __recalculate_layout;
    __recalculate_layout;
  fi;

  echo "[$LAYOUT_PID]";
}

once_layout() {
  if (echo -e "$BSP_DEFAULT_LAYOUTS" | grep "^$1$"); then exit 0; fi
  local focused_desktop=$(get_focused_desktop);
  local selected_desktop="${2:-$focused_desktop}";

  __calculate_layout() {
    setup_layout "$@";
    run_layout "$@";
    run_layout "$@";
  }

  if [[ "$selected_desktop" != "$focused_desktop" ]]; then
    bspc subscribe desktop_focus | while read line; do
      event=$(echo "$line" | awk '{print $1}');
      desktop_id=$(echo "$line" | awk '{print $3}');
      desktop_name=$(get_desktop_name_from_id "$desktop_id");

      if [[ "$desktop_name" = "$selected_desktop" ]]; then
        __calculate_layout "$@";
        exit 0
      fi;
    done & disown;
  else
    __calculate_layout "$@";
  fi;
}

reload_layouts() {
  list_desktops | while read desktop; do
    layout=$(get_desktop_options "$desktop" | valueof layout);
    [[ ! -z "$layout" ]] && start_listener $layout $desktop;
  done;
}

# Check for dependencies
for dep in bc bspc man; do
  !(which $dep >/dev/null 2>&1) && echo "[Missing dependency] bsp-layout needs $dep installed" && exit 1;
done;

action=$1; shift;

case "$action" in
  reload)            reload_layouts ;;
  once)              once_layout "$@" ;;
  set)               start_listener "$@" ;;
  previous)          previous_layout "$@" ;;
  next)              next_layout "$@" ;;
  get)               get_layout "$@" ;;
  remove)            remove_listener "$1" ;;
  layouts)           list_layouts ;;
  -h|--help|help)    man bsp-layout ;;
  -v|version)        echo "$VERSION" ;;
  *)                 echo -e "Unknown subcommand. Run bsp-layout help" && exit 1 ;;
esac

