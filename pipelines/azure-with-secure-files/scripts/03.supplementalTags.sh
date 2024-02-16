#!/bin/sh

### This script is specific to Azure DevOps. It adds some other tags
# shellcheck source-path=SCRIPTDIR/../../..
. ./build/setParameters.sh

env | grep -v PASS | sort

tag1="${DST_CONTAINER_IMAGE_REPOSITORY_TAG}-brsn-$BUILD_REASON"

export DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS="$DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS $tag1"

if [ "$BUILD_SOURCEBRANCHNAME" = "main" ]; then
    echo ">>>>>>>>>>>>>>> Built on main branch"
    export DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS="latest $DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS"
else
    echo "Building against non-main branch $BUILD_SOURCEBRANCHNAME ..."
fi

echo "##vso[task.setvariable variable=DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS;]${DST_CONTAINER_IMAGE_REPOSITORY_SUPPLEMENTAL_TAGS}"