#!/usr/bin/env bash
set -o errexit -o pipefail -o xtrace

chmod ugo+x /bin/run.bash
user1000=$(id --name --user 1000)
/usr/bin/su --command '/bin/bash -o errexit -o pipefail -o xtrace /bin/run.bash' "${userName:=user1000}"
