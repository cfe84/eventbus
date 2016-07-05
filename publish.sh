#!/bin/bash

VERSION=`cat version.txt`
REVISION=`git describe | sed -E s/[^-]*-\([0-9]+\)-.*$/\\1/g`

cat package.json.template | sed s/%VERSION%/$VERSION.$REVISION/g > bin/package.json

cd bin
npm publish