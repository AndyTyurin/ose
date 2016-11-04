#!/usr/bin/env bash

# Update minor version (x.MINOR.z.hotfix-w).
current_version=`sh version.sh`
sh ./_upversion.sh 0 1 0 0
sh ./_pushversion.sh current_version
