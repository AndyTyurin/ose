#!/usr/bin/env bash

cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

# Update major version (MAJOR.y.z.hotfix-w).
sh ./_upversion.sh 1 0 0
