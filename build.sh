#!/bin/bash


FOLDERS="."
BASE="src"
OUTPUT="bin"


./clean.sh

echo "Building"

[ ! -d "$OUTPUT" ] && mkdir "$OUTPUT"

for FOLDER in $FOLDERS; do
    [ ! -d "$OUTPUT/$FOLDER" ] && mkdir "$OUTPUT/$FOLDER"
    coffee -o $OUTPUT/$FOLDER/ -c $BASE/$FOLDER/*.coffee
done
