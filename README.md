# r-docker

### Tags
- `3.1-xenial`, `3.1-bionic`, `3.1-centos6`, `3.1-centos7`, `3.1-opensuse42`, `3.1-opensuse15`
- `3.2-xenial`, `3.2-bionic`, `3.2-centos6`, `3.2-centos7`, `3.2-opensuse42`, `3.2-opensuse15`
- `3.3-xenial`, `3.3-bionic`, `3.3-centos6`, `3.3-centos7`, `3.3-opensuse42`, `3.3-opensuse15`
- `3.4-xenial`, `3.4-bionic`, `3.4-centos6`, `3.4-centos7`, `3.4-opensuse42`, `3.4-opensuse15`
- `3.5-xenial`, `3.5-bionic`, `3.5-centos6`, `3.5-centos7`, `3.5-opensuse42`, `3.5-opensuse15`
- `xenial`, `bionic`, `centos6`, `centos7`, `opensuse42`, `opensuse15` (base images without R)

### Building Images
```bash
# Build and test all images
make

# Build and test images for a specific R version
make VERSIONS=3.4

# Build and test images for a specific distro
make VARIANTS=xenial

# Build a specific image
make build-3.4-xenial

# Test a specific image
make test-3.4-xenial
```

### Updating Images
1. Update [`update.sh`](update.sh) and [Makefile](Makefile) with the new distro or R version
2. Generate new Dockerfiles:
```bash
make update-all

# Or, using Docker
make update-all-docker
```
3. Build and test the new images locally
4. Submit a pull request