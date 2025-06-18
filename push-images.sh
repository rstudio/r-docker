#!/bin/bash

set -e

# Pushes images for a specific R version and variant, e.g.:
#
# - posit/r-base:4.4-noble -> posit/r-base:4.4-noble
#   posit/r-base:4.4-noble -> posit/r-base:4.4.3-noble
#
# - posit/r-base:4.4-noble -> posit/r-base:4.4-noble-arm64
#   posit/r-base:4.4-noble -> posit/r-base:4.4.3-noble-arm64
#
# - posit/r-base:4.4-noble -> rstudio/r-base:4.4-noble
#   posit/r-base:4.4-noble -> rstudio/r-base:4.4.3-noble
#
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4 VARIANT=noble ./push-images.sh
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4 VARIANT=noble ARCH=arm64 ./push-images.sh
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4.3 VARIANT=noble ./push-images.sh
# Usage: BASE_IMAGE=posit/r-base VERSION=4.4.3 VARIANT=noble ARCH=arm64 ./push-images.sh
# Usage: BASE_IMAGE=posit/r-base TARGET_BASE_IMAGE=rstudio/r-base VERSION=4.4 VARIANT=noble ./push-images.sh

if [ -n "$ARCH" ]; then
    arch="-${ARCH}"
fi

# The local source image (tagged a minor R version and no arch, e.g. 4.4-noble)
source_image="${BASE_IMAGE}:${VERSION}-${VARIANT}"

target_base_image=${TARGET_BASE_IMAGE:-$BASE_IMAGE}

# The default image to push (e.g., 4.4-noble or 4.4-noble-arm64)
target_image="${target_base_image}:${VERSION}-${VARIANT}${arch}"

echo "Pushing default image: $target_image"
docker tag "$source_image" "$target_image"
docker push "$target_image"

# Push the patch version alias if applicable, e.g. 4.4-noble.
# This is skipped if pushing a patch version image, e.g. 4.4.3-noble.
if [ -f "${VERSION}/${VARIANT}/version.txt" ]; then
    patch_version=$(cat "${VERSION}/${VARIANT}/version.txt")

    # The patch alias image to push (e.g., 4.4.3-noble or 4.4.3-noble-arm64)
    target_patch_image="${target_base_image}:${patch_version}-${VARIANT}${arch}"

    echo "Pushing patch image: $target_patch_image"
    docker tag "$source_image" "$target_patch_image"
    docker push "$target_patch_image"
fi
