#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

hyperfine --style basic --export-markdown hyperfine.md --output ./pyramid.txt --shell none 'smileypyramid 10' &
pid=$!
top -b -n 1
wait $pid
cat pyramid.txt
cat hyperfine.md
