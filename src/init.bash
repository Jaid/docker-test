#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

addgroup --system --gid "$groupId" "$groupName"
adduser --disabled-password --gecos '' --uid "$userId" --ingroup "$groupName" --home "$userHome" --no-create-home --shell /bin/bash "$userName"
mkdir --parents "$userHome"/bin
chown --recursive "$userId":"$groupId" "$userHome"
