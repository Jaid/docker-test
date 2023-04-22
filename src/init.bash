#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

# shellcheck disable=SC2154
groupadd --system --gid "$groupId" "$groupName"
# shellcheck disable=SC2154,SC2312
useradd --disabled-password --gecos '' --uid "$userId" --gid "$groupName" --home "$userHome" --no-create-home --shell "$(command -v bash)" "$userName"
mkdir --parents "$userHome"/bin
chown --recursive "$userId:$groupId" "$userHome"
