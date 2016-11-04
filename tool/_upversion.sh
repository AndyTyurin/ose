#!/usr/bin/env bash

MAJOR=$1
MINOR=$2
PATCH=$3
HOTFIX=$4

cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

readonly CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
readonly SERVER_ALIAS="origin"

if [[ "$CURRENT_BRANCH" != "master" ]]; then
    >&2 echo "Update version is available only for master branch."
    exit 1
fi

current_version=`sh version.sh`
pattern='([[:digit:]]*)\.([[:digit:]]*)\.([[:digit:]]*)$'

if [[ "$current_version" != "" ]]; then
    if [[ "$current_version" =~ $pattern ]]; then
        major="${BASH_REMATCH[1]}"
        minor="${BASH_REMATCH[2]}"
        patch="${BASH_REMATCH[3]}"

        major=$((MAJOR+major))
        minor=$((MINOR+minor))
        patch=$((PATCH+patch))

        version="$major.$minor.$patch"

        if [[ MAJOR -ne 0 ]] || [[ MINOR -ne 0 ]] || [[ PATCH -ne 0 ]]; then
            echo "Next version: v$version"
            # Update pubspec.
            sed -i '' "s/^version:.*/version: $version/g" "./../pubspec.yaml" && echo "Updated v$current_version => v$version"

            sh ./_pushversion.sh current_version
        fi
    fi
else
    >&2 echo "Error occurred. Please set first version in your pubspec."
fi
