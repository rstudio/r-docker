#!/bin/bash

set -e

# Pushes a multiarch image for a specific R version and variant. Assumes that the
# source images for both amd64 and arm64 are already available in the remote registry.
#
# - posit/r-base:4.4-noble-amd64, posit/r-base:4.4-noble-arm64 -> posit/r-base:4.4-noble
# - posit/r-base:4.4.3-noble-amd64, posit/r-base:4.4.3-noble-arm64 -> posit/r-base:4.4.3-noble
#
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4 VARIANT=noble ./push-multiarch.sh
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4.3 VARIANT=noble ./push-multiarch.sh

target_image="${BASE_IMAGE}:${VERSION}-${VARIANT}"
source_image_amd64="${BASE_IMAGE}:${VERSION}-${VARIANT}-amd64"
source_image_arm64="${BASE_IMAGE}:${VERSION}-${VARIANT}-arm64"

echo "Pushing multiarch image '$target_image' from: $source_image_amd64 and $source_image_arm64"

docker manifest create "$target_image" \
    --amend "$source_image_amd64" \
    --amend "$source_image_arm64"

docker manifest push "$target_image"

# Push the patch version alias if applicable, e.g. 4.4-noble.
# This is skipped if pushing a patch version image, e.g. 4.4.3-noble.
if [ -f "${VERSION}/${VARIANT}/version.txt" ]; then
    patch_version=$(cat "${VERSION}/${VARIANT}/version.txt")

    target_image="${BASE_IMAGE}:${patch_version}-${VARIANT}"
    source_image_amd64="${BASE_IMAGE}:${patch_version}-${VARIANT}-amd64"
    source_image_arm64="${BASE_IMAGE}:${patch_version}-${VARIANT}-arm64"

    echo "Pushing multiarch image '$target_image' from: $source_image_amd64 and $source_image_arm64"

    docker manifest create "$target_image" \
        --amend "$source_image_amd64" \
        --amend "$source_image_arm64"

    docker manifest push "$target_image"
fi
