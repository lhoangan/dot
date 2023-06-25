
period_commit() {
    [ -z "$1" ] && msg="Update" || msg="$1"
    while true; do git add --all ; git commit -m $msg ; git push origin master; sleep 24h ; done
}

monitor_this() {
    path="$1"
    inotifywait -m $path -e create -e moved_to |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action'"
        # do something with the file
    done
}
