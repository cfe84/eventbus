#!/bin/bash

echo "Building"
./build.sh

echo "Building tests"
rm test/*.js
coffee -o test -C test/*.coffee

echo "Running tests"
cd bin

for TEST in `ls ../test/ | grep test_*.js`