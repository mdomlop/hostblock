#!/bin/sh
# systemd-hosts-adblock
umask 0022

merge() {
    echo "Merging /etc/hosts.d/*... "
    cat /etc/hosts.d/* > /etc/hosts
}

adblock() {
    echo "Blocking adds... "
    adblock='http://winhelp2002.mvps.org/hosts.txt'
    # Grepping only 0.0.0.0 starting lines for security reasons.
    curl -s "$adblock" | grep ^'0.0.0.0 ' > /etc/hosts.d/adblock.block
}

adunblock() {
    echo "Unblocking adds... "
    rm /etc/hosts.d/*.block
}

for i in "$@"
do
    "$i"
done

