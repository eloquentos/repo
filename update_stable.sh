#!/bin/bash

repo-add /tmp/stable.db.tar.gz /srv/arch/current/*/os/x86_64/*.pkg.tar.xz
rm /srv/repo/stable/x86_64/*
ln -s /srv/arch/current/*/os/x86_64/*.pkg.* /srv/repo/stable/x86_64/
mv /tmp/stable.db* /srv/repo/stable/x86_64/

repo-add /tmp/stable.db.tar.gz /srv/arch/current/*/os/i686/*.pkg.tar.xz
rm /srv/repo/stable/i686/*
ln -s /srv/arch/newest/*/os/i686/*.pkg.* /srv/repo/stable/i686/
mv /tmp/stable.db* /srv/repo/stable/i686
