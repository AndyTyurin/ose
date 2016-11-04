#!/usr/bin/env bash

# Update patch version (x.y.PATCH.hotfix-w).
current_version=`sh version.sh`
sh ./_upversion.sh 0 0 1 0
sh ./_pushversion.sh current_version
