#!/usr/bin/env bash
set -o errexit -o pipefail

aptGet update
aptGet upgrade
aptGet install curl build-essential flex texinfo gettext automake pkg-config
aptGet autoclean
aptGet autoremove
rm --recursive --force /var/log/* /var/lib/apt/lists/* /var/cache/apt/archives/* /usr/share/doc /usr/share/man
