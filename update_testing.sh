#!/bin/bash

home="/srv"
target="${home}/arch/newest"
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
        --link-dest="${home}/arch/current" \
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

rm -rf /srv/packages/testing/builds
git clone https://github.com/eloquentos/system-packages /srv/packages/testing/builds

for i in /srv/packages/testing/builds/* ; do
    if [ -d "$i" ]; then
        cd "$i"
        makepkg
    fi
done

mkdir -p /srv/packages/testing/packages
repo-add /tmp/testing.db.tar.gz /srv/packages/testing/builds/*/*.pkg.*

repo-add /tmp/testing.db.tar.gz /srv/packages/testing/builds/*/*.pkg.*
repo-add /tmp/testing.db.tar.gz /srv/arch/newest/*/os/x86_64/*.pkg.tar.xz
rm /srv/repo/testing/x86_64/*
rm -rf /srv/packages/testing/packages
cp /srv/packages/testing/builds/*/*.pkg.* /srv/packages/testing/packages
ln -s /srv/packages/testing/packages/*.pkg.*  /srv/repo/testing/x86_64
ln -s /srv/arch/newest/*/os/x86_64/*.pkg.* /srv/repo/testing/x86_64/
mv /tmp/testing.db* /srv/repo/testing/x86_64/

repo-add /tmp/testing.db.tar.gz /srv/packages/testing/builds/*.pkg.*
repo-add /tmp/testing.db.tar.gz /srv/arch/newest/*/os/i686/*.pkg.tar.xz
rm /srv/repo/testing/i686/*
rm -rf /srv/packages/testing/packages
cp /srv/packages/testing/builds/*/*.pkg.* /srv/packages/testing/packages
ln -s /srv/packages/testing/packages/*.pkg.*  /srv/repo/testing/i686
ln -s /srv/arch/newest/*/os/i686/*.pkg.* /srv/repo/testing/i686/
mv /tmp/testing.db* /srv/repo/testing/i686

#echo "Last sync was $(date -d @$(cat ${target}/lastsync))"
