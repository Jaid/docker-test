#!/usr/bin/env bash
set -o errexit -o pipefail

# shellcheck disable=SC2154
userBinFolder=$userHome/userBin
find "$userBinFolder" -maxdepth 1 -type f -printf '%P\0' | while read -r -d $'\0' file; do
  fullPath="$userBinFolder/$file"
  fileWithoutExtension=$(printf %s "$file" | sed 's|\.\w\+$||')
  mv "$fullPath" "/bin/$fileWithoutExtension"
  chmod ugo+x "/bin/$fileWithoutExtension"
done
rm /bin/registerUserBin
