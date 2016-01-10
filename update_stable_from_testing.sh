#!/bin/bash

mv /srv/arch/current /srv/arch/old
mv /srv/arch/newest /srv/arch/current
mv /srv/repo/stable /srv/repo/old
rm /srv/repo/testing/*.pkg.*
ln -s /srv/arch/current/*/os/x86_64/*.pkg.* /srv/repo/testing/x86_64/
ln -s /srv/arch/current/*/os/i686/*.pkg.* /srv/repo/testing/i686/
cp /srv/repo/testing /srv/repo/stable
mv /srv/repo/stable/testing.db.tar.gz /srv/repo/stable/stable.db.tar.gz
ln -sfn /srv/repo/stable/stable.db.tar.gz /srv/repo/stable/stable.db
rm -rf /srv/arch/old
rm -rf /srv/repo/old
