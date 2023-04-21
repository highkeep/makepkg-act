#!/bin/bash

git-svn() {
    git svn clone ${1} --trunk=trunk/${2} $(basename ${2})
}

checkGitVersion() {
    REPO_URL="$1"
    REPO_PKG="$2"

    remoteVersion=$(git ls-remote -q ${REPO_URL}/${REPO_PKG}.git heads/master | cut -f1)
    currentVersion=$(/usr/bin/cat versions/${REPO_PKG} 2>/dev/null)

    if [[ "${remoteVersion}" != "${currentVersion}" ]]; then
        echo "update=true"
    else
        echo "update=false"
    fi
}

genLocalSum() {
    find ${1} -type f -exec md5sum {} \; | cut -d" " -f1 | sha256sum | cut -f1 -d" "
}

checkLocalVersion() {
    REPO_PKG="$1"

    remoteVersion=$(genLocalSum ${REPO_PKG})
    currentVersion=$(/usr/bin/cat versions/${REPO_PKG} 2>/dev/null)

    if [[ "${remoteVersion}" != "${currentVersion}" ]]; then
        echo "update=true"
    else
        echo "update=false"
    fi
}

setArch() {
    sed -i -r "s/(march=)[A-Za-z0-9-]+(\s?)/\1${1}\2/g" ${2}
    sed -i -r "s/(mtune=)[A-Za-z0-9-]+(\s?)/\1${1}\2/g" ${2}
    sed -i -r "s/(target-cpu=)[A-Za-z0-9-]+(\s?)/\1${1}\2/g" ${2}
}
