#!/bin/bash

mv /srv/arch/current /srv/arch/old
mv /srv/arch/newest /srv/arch/current
mv /srv/repo/stable /srv/repo/old
mv /srv/packages/stable /srv/packages/old
mv /srv/packages/testing /srv/packages/stable
rm /srv/repo/testing/x86_64/*.pkg.*
rm /srv/repo/testing/i686/*.pkg.*
ln -s /srv/arch/current/*/os/x86_64/*.pkg.* /srv/repo/testing/x86_64/
ln -s /srv/arch/current/*/os/i686/*.pkg.* /srv/repo/testing/i686/
ln -s /srv/packages/stable/packages/x86_64/*.pkg.* /srv/repo/testing/x86_64
ln -s /srv/packages/stable/packages/i686/*.pkg.* /srv/repo/testing/i686
cp -R /srv/repo/testing /srv/repo/stable
mv /srv/repo/stable/x86_64/testing.db.tar.gz /srv/repo/stable/x86_64/stable.db.tar.gz
mv /srv/repo/stable/i686/testing.db.tar.gz /srv/repo/stable/i686/stable.db.tar.gz
ln -sfn /srv/repo/stable/x86_64/stable.db.tar.gz /srv/repo/stable/x86_64/stable.db
ln -sfn /srv/repo/stable/i686/stable.db.tar.gz /srv/repo/stable/i686/stable.db
rm -rf /srv/arch/old
rm -rf /srv/repo/old
rm -rf /srv/packages/old
