#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

userId=${userId:-1000}
userName=${userName:-}
groupId=${groupId:-1000}
groupName=${groupName:-$userName}
userHome=${userHome:-}

existingUser=$(id --name --user "$userId" || true)
existingGroup=$(id --name --group "$groupId" || true)
if [[ -n "$existingUser" ]]; then
  usermod --uid 1001 "$existingUser"
fi
if [[ -n "$existingGroup" ]]; then
  groupmod --gid 1001 "$existingGroup"
fi
userAddArguments=()
if [[ -n "$userHome" ]]; then
  userAddArguments+=(--home)
  userAddArguments+=("$userHome")
  if [[ -d "$userHome" ]]; then
    userAddArguments+=(--no-create-home)
  fi
else
  userAddArguments+=(--no-create-home)
fi
bashPath=$(command -v bash || true)
if [[ -n "$bashPath" ]]; then
  userAddArguments+=(--shell)
  userAddArguments+=("$bashPath")
fi
if [[ -n "$groupName" ]]; then
  groupadd --system --gid "$groupId" "$groupName"
  userAddArguments+=(--gid)
  userAddArguments+=("$groupName")
fi
useradd --uid "$userId" --home "$userHome" "$userName" "${userAddArguments[@]}"

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
aptGet install git curl build-essential flex texinfo gettext automake pkg-config cmake
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
