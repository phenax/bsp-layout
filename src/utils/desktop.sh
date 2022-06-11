source "$ROOT/utils/config.sh";
names="--names"
[[ $USE_NAMES -eq 0 ]] && names="";
get_focused_desktop() { bspc query -D -d 'focused' $names; }
get_desktop_name_from_id() { bspc query -D -d "$1" $names; }

