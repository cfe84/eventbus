#!/bin/bash

echo "Cleaning"

FOLDERS="src test bin"

for FOLDER in $FOLDERS; do
    rm $FOLDER/*.js
done