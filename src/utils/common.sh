jget() {
    key=$1
    shift
    var=${*#*\"$key\":}
    var=${var%%[,\}]*}
    echo "$var"
}
