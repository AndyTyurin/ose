#!/usr/bin/env bash

# Update major version (MAJOR.y.z.hotfix-w).
current_version=`sh version.sh`
sh ./_upversion.sh 1 0 0
sh ./_pushversion.sh current_version
