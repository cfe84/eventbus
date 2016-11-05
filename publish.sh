#!/bin/sh

./test.sh

echo "Publishing"

git describe --long | sed -E s/[^-]*-\([0-9]+\)-.*/\\1/ > revision.txt

REVISION=`cat revision.txt`
VERSION=`cat version.txt`

cat package.json.template | sed s/%VERSION%/$VERSION.$REVISION/g > bin/package.json

cd bin
npm publish