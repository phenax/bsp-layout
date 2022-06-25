# str -> str
jget() {
    # TODO.
    key=$1
    shift
    var=${*#*\"$key\":}
    var=${var%%[,\}]*}
    echo "$var"
}
