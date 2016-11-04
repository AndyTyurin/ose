#!/usr/bin/env bash

cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

# Update minor version (x.MINOR.z.hotfix-w).
sh ./_upversion.sh 0 1 0 0
