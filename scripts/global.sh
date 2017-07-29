#!/bin/bash

set -e

# tl;dr npm i -g with current src as tarball

inst="$npm_config_prefix"
[ -z "$inst" ] && inst="/usr"
inst="$inst/lib/node_modules"

instdir="$inst/zeronet"

rm -rf .pkg
mkdir .pkg
for f in package* zeronet.js lib npm-shrinkwrap.json .gitignore LICENSE; do cp -r $f .pkg; done
#ver=$(echo $(cat package.json | grep "version" | sed "s|\"||g" | sed "s|  ||g" | grep " .*" -o) | sed "s|,||g")
cd .pkg
for f in package* npm-shrinkwrap.json; do sed -r 's|"([a-z-]+)": "file:(.*)"|"\1": "file:./\2.tar.gz"|g' -i $f; done
mkdir -p $instdir
mv ../*.tar.gz $instdir
tar cvfz ../znjs.tar --mtime='2015-10-21 00:00Z' --sort=name --owner=0 --group=0 --numeric-owner --mode="777" . | sed "s|^|zeronet-js: |g"
cat ../znjs.tar | gzip -n > ../znjs.tar.gz
rm  ../znjs.tar
mv ../znjs.tar.gz .
npm i ./znjs.tar.gz --unsafe-perm --production -g
