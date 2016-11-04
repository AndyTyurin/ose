#!/usr/bin/env bash

cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

current_version=''
current_version_sum=0
pattern='([[:digit:]]*)\.([[:digit:]]*)\.([[:digit:]]*)$'

version=`sed -n '/version: /{p;q;}' ./../pubspec.yaml`
if [[ "$version" != '' ]]; then
    version="${version##version: }"
    if [[ "$version" =~ $pattern ]]; then
        major="${BASH_REMATCH[1]}"
        minor="${BASH_REMATCH[2]}"
        patch="${BASH_REMATCH[3]}"

        major=$((major*1000))
        minor=$((minor*100))
        patch=$((patch*10))

        version_sum=$((major+minor+patch))

        if [[ ${current_version_sum} -lt ${version_sum} ]]; then
            current_version="${version}"
            current_version_sum=$((version_sum))
        fi
    fi
fi

echo "$current_version" && exit 1
