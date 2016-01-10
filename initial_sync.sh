#!/bin/bash

home="/srv"
target="${home}/arch/current"
tmp="${home}/tmp"
lock='/tmp/mirrorsync.lck'
bwlimit=4096
# NOTE: you very likely need to change this since rsync.archlinux.org requires you to be a tier 1 mirror
source='rsync://mirrors.uk2.net/archlinux/'
lastupdate_url="http://archlinux.mirrors.uk2.net/lastupdate"

[ ! -d "${target}" ] && mkdir -p "${target}"
[ ! -d "${tmp}" ] && mkdir -p "${tmp}"

exec 9>"${lock}"
flock -n 9 || exit

# if we are called without a tty (cronjob) only run when there are changes
#if ! tty -s && diff -b <(curl -s "$lastupdate_url") "$target/lastupdate" >/dev/null; then
#       exit 0
#fi

if ! stty &>/dev/null; then
    QUIET="-q"
fi

rsync -rtlvH --safe-links --delete-after --progress -h ${QUIET} --timeout=600 --contimeout=60 -p \
        --delay-updates --no-motd --bwlimit=$bwlimit \
        --temp-dir="${tmp}" \
        --exclude='*.links.tar.gz*' \
        --exclude='/other' \
        --exclude='/sources' \
        --exclude='/iso' \
        --exclude='/testing' \
        --exclude='/staging' \
        --exclude='/community-testing' \
        --exclude='/community-staging' \
        --exclude='/multilib-testing' \
        --exclude='/multilib-staging' \
        --exclude='/gnome-unstable' \
        --exclude='/kde-unstable' \
        ${source} \
        "${target}"

#echo "Last sync was $(date -d @$(cat ${target}/lastsync))"





