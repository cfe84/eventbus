#!/bin/bash

echo "Building"
./build.sh

echo "Running tests"

coffee test/test_*.coffee