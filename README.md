# r-docker

### Tags
- `3.4-xenial`, `3.4-bionic`
- `3.5-xenial`, `3.5-bionic`
- `xenial`, `bionic` (base images without R)

### Building
```bash
# Build and test all images
make

# Build and test images for a specific R version
make VERSIONS=3.4

# Build and test images for a specific distro
make VARIANTS=xenial

# Build a specific image
make build-r-3.4-xenial

# Test a specific image
make test-r-3.4-xenial
```