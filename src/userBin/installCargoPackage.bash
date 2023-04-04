#!/usr/bin/env bash
set -o errexit -o pipefail

PATH=$PATH:$HOME/.cargo/bin
export PATH
rustTarget=$(rustc -vV | sed -n 's|host: ||p')
cargo install --target "$rustTarget" --force "$@" --root /
