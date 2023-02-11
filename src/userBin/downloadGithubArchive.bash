#!/usr/bin/env bash
set -o errexit -o pipefail

repoSlug=$1
repoOwner=${repoSlug%%/*}
repoName=${repoSlug##*/}
finalFolderName=$2
if [[ -n $3 && -n $4 ]]; then
  if [[ $3 = sha ]]; then
    commit=$4
    folderName=$repoName-$4
  else
    commit=refs/heads/$4
    folderName=$repoName-$4
  fi
else
  commit=refs/heads/main
  folderName=$repoName-main
fi

curl --location --retry 3 --fail --silent --show-error --header 'Cache-Control: no-cache' "https://github.com/$repoOwner/$repoName/archive/$commit.tar.gz" | tar -x -z -f -
if [[ -n $folderName ]]; then
  mv "$folderName" "$finalFolderName"
fi
