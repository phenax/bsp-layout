# import the lib.
source "$ROOT/utils/config.sh"

names="--names"
[[ $USE_NAMES -eq 0 ]] && names=""

# () -> desktop
get_focused_desktop() {
    local desktop=$(bspc query -D -d 'focused' $names)
    echo "$desktop"
}

# int -> desktop
get_desktop_name_from_id() {
    local id=$1
    local desktop_name=$(bspc query -D -d "$id" $names)
    echo "$desktop_name"
}
