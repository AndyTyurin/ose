cd $OLDPWD "$(dirname "${BASH_SOURCE}")"

version=`sh version.sh`

PREV_VERSION=$1

git add ./../pubspec.yaml &&
git commit -m  "Bump version" &&
git tag "v$version" &&
git push origin ${CURRENT_BRANCH} --tags &&
echo "\nDone v$PREV_VERSION => v$version." &&
exit 1
