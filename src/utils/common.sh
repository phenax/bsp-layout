# str -> str
jget() {
    # TODO.
    key=$1
    shift
    var=${*#*\"$key\":}
    var=${var%%[,\}]*}
    echo "$var"
}

# () -> ()
check_dependencies () {
  for dep in bc bspc man; do
    !(which $dep >/dev/null 2>&1) && {
      echo "[Missing dependency] bsp-layout needs $dep installed"
      exit 1
    }
  done
}
