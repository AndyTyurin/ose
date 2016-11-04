#!/usr/bin/env bash

cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

# Update patch version (x.y.PATCH.hotfix-w).
sh ./_upversion.sh 0 0 1 0
