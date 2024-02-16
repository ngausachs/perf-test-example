#!/bin/sh

# shellcheck source-path=SCRIPTDIR/..
. ./build/setParameters.sh

buildah logout "${SRC_CONTAINER_IMAGE_REGISTRY_URL}"
if [ "${SRC_CONTAINER_IMAGE_REGISTRY_URL}" != "${DST_CONTAINER_IMAGE_REGISTRY_URL}" ]; then 
    buildah logout "${DST_CONTAINER_IMAGE_REGISTRY_URL}"
fi
