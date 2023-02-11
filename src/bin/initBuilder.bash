#!/usr/bin/env bash
set -o errexit -o pipefail

# shellcheck disable=SC2154
addgroup --system --gid "$groupId" "$groupName"
# shellcheck disable=SC2154
adduser --disabled-password --gecos '' --uid "$userId" --ingroup "$groupName" --home "$userHome" --no-create-home --shell /bin/bash "$userName"
mkdir --parents "$userHome/bin"
mkdir --parents "$userHome/userBin"
chown --recursive "$userId":"$groupId" "$userHome"
rm /bin/initBuilder
