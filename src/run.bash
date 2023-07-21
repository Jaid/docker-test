#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

echo "$1"
if [[ $base = a ]]; then
  pyramidSize=10
else
  pyramidSize=20
fi
hyperfine --style basic --export-markdown hyperfine.md --output ./pyramid.txt --shell none "smileypyramid $pyramidSize" &
pid=$!
top -b -n 1
wait $pid
cat pyramid.txt
cat hyperfine.md
