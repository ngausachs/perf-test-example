#!/bin/sh

# shellcheck source-path=SCRIPTDIR/..
. ./build/setParameters.sh

# Artifacts to pull

rm -rf /tmp/git

mkdir -p /tmp/git

# Unit test tool
git clone -b main --single-branch https://github.com/SoftwareAG/WxIsTestTools.git /tmp/git/WxIsTestTools || exit 1
