#!/bin/sh
# hostblock.sh

umask 0022

blockdir='/etc/hosts.d'
adblock='http://winhelp2002.mvps.org/hosts.txt'
syshost='/etc/hosts'

merge() {
    echo "Merging "$blockdir"/*... "
    cat "$blockdir"/* > "$syshost"
}

adblock() {
    echo "Blocking adds... "
    # Grepping only 0.0.0.0 starting lines for security reasons.
    curl -s "$adblock" | grep ^'0.0.0.0 ' > "$blockdir"/adblock.block
}

adunblock() {
    echo "Unblocking adds... "
    rm "$blockdir"/*.block
}

if [ ! -d "$blockdir" ]
then
    mkdir -p "$blockdir" || exit 1
    echo "WARNING: Moving $syshost to $dir/hosts.original"
    cat "$syshost" > "$dir/hosts.original"
fi

for i in "$@"
do
    "$i"
done

