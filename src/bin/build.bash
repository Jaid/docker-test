#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

cat /etc/group
cat /etc/passwd
existingUser1000=$(id --name --user 1000)
existingGroup1000=$(id --name --group 1000)
if [[ -n "$existingUser1000" ]]; then
  echo "User 1000 already exists: $existingUser1000, moving to id 1001"
  usermod --uid 1001 "$existingUser1000"
fi
if [[ -n "$existingGroup1000" ]]; then
  echo "Group 1000 already exists: $existingGroup1000, moving to id 1001"
  groupmod --gid 1001 "$existingGroup1000"
fi
# shellcheck disable=SC2154
groupadd --system --gid "$groupId" "$groupName"
# shellcheck disable=SC2154,SC2312
useradd --disabled-password --gecos '' --uid "$userId" --gid "$groupName" --home "$userHome" --no-create-home --shell "$(command -v bash)" "$userName"
mkdir --parents "$userHome/bin"
chown --recursive "$userId:$groupId" "$userHome"

# shellcheck disable=SC2154
userBinFolder=$userHome/userBin
find "$userBinFolder" -maxdepth 1 -type f -printf '%P\0' | while read -r -d $'\0' file; do
  fullPath="$userBinFolder/$file"
  fileWithoutExtension=$(printf %s "$file" | sed 's|\.\w\+$||')
  mv "$fullPath" "/bin/$fileWithoutExtension"
  chmod ugo+x "/bin/$fileWithoutExtension"
done

aptGet update
aptGet install curl build-essential flex texinfo gettext automake pkg-config cmake
downloadGithubArchive krallin/tini tini sha 378bbbc8909a960e89de220b1a4e50781233a740

cd tini
cmake .
make
cd ..
# rm --recursive --force tini

curl --location --retry 3 --fail --silent --show-error --header 'Cache-Control: no-cache' https://sh.rustup.rs | sh -s -- -y --no-modify-path
rm --recursive --force ~/.rustup/toolchains/*/share

installCargoPackage hyperfine
installCargoPackage smileypyramid

aptGet autoclean
aptGet autoremove

rm --recursive --force /var/log/*
rm --recursive --force /var/lib/apt/lists/*
rm --recursive --force /var/cache/apt/archives/*
rm --recursive --force /usr/share/doc
rm --recursive --force /usr/share/man
