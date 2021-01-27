# RStudio R Docker Images

[![CircleCI Build Status](https://circleci.com/gh/rstudio/r-docker.svg?style=svg)](https://circleci.com/gh/rstudio/r-docker)

RStudio creates and [distributes an opinionated set of R
binaries](https://github.com/rstudio/r-builds) for different Linux
distributions. These Docker images are built to use those R binaries. *The
images are intentionally minimal, their primary purpose is to serve as the
basis for other images requiring R.* 

For a quick way to get started with R or RStudio, 
refer to the [Rocker project](https://www.rocker-project.org/).

> *WARNING*: These images are considered experimental, and may change. They should
> not be used for strictly reproducible environments (yet!). 

### Sample Usage

These images can be used to execute R:

```
docker run --rm -it rstudio/r-base:4.0-focal
```

These images can also be used as the basis for other custom images. To get
started, use an image as the base in a Dockerfile:

```dockerfile
FROM rstudio/r-base:4.0-focal
```

### Releases and Tags

The images follow these tag patterns: 

| Pattern | Example | Description |
| --- | --- | --- | 
| `rstudio/r-base:distro` | `rstudio/r-base:centos8` |  Base operating system + system libraries required by R. |
| `rstudio/r-base:x.y.z-distro` | `rstudio/r-base:4.0.3-centos8` | R version `x.y.z` on the specified OS |
| `rstudio/r-base:x.y-distro` | `rstudio/r-base:4.0-centos8` | Latest R version `x.y.z` on the specified OS, where the patch version `z` floats over time. For example, if R 4.0.4 is released, `rstudio/r-base:4.0-centos8` would switch from R 4.0.3 to R 4.0.4.|


The following distributions are supported:  

| Distribution  | Full Name |
| ------------- |-----------|
| xenial        | Ubuntu 16.04 |
| bionic        | Ubuntu 18.04 |
| focal         | Ubuntu 20.04 |
| centos7       | CentOS 7 |
| centos8       | CentOS 8 |
| opensuse42    | openSUSE 42.3 |
| opensuse15    | openSUSE 15.0 |
| opensuse152   | openSUSE 15.2 |

All minor versions of R since 3.1 are supported, on the latest patch release.

New versions of R are added when they're available on the
[RStudio CDN](https://cdn.rstudio.com/r/versions.json), though there may be
some delay between the release of R and the release of the Docker image.

New operating systems are added on a less frequent basis. 


### What is R?

R is a language and environment for statistical computing and graphics. For more information:

- [R Home](https://www.r-project.org/about.html)
- [R for Data Science](https://r4ds.had.co.nz/) 

### Resources

- [Using Docker with R](https://environments.rstudio.com/docker)
- [Using Docker with RStudio Server Pro](https://solutions.rstudio.com/launcher/overview/) 

### Support

RStudio does not provide professional support for these images or the R
language. The best place to ask questions and provide feedback is the [RStudio
Community](https://community.rstudio.com/).

### License

View license information for [R](https://www.r-project.org/Licenses/).


---

## Developer Resources

The following section contains information for those wishing to build these
images themselves.

In general, the structure consists of the following:

- `base`: Base images that start with a minimal OS and add the necessary system
  requirements required by R.
- `x.y`: Images for each major.minor version of R. These images start from the
  `base` images and add R, copied from the RStudio CDN. 


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

1. Update [`update.sh`](update.sh) and [`Makefile`](Makefile) with the new distro or R version
2. Update [`.circleci/config.yml`](.circleci/config.yml)
3. Update [`README.md`](README.md)
4. Create a new /base/<distro>/Dockerfile
5. Generate new Dockerfiles:
    ```bash
    make update-all

    # Or, using Docker
    make update-all-docker
    ```
6. Build and test the new images locally
7. Submit a pull request

### Rebuilding Images

Rebuild images when the R build has been updated but there are no Dockerfile or base image changes.
This ignores the Docker cache and reinstalls R in the image.

```bash
# rebuild all images
make rebuild-all

# Rebuild a specific image.
make rebuild-3.4-xenial
```

### Notes

- 1/27/2021 - rebuilt from base to mitigate the [Baron Samedit vulnerability](https://blog.qualys.com/vulnerabilities-research/2021/01/26/cve-2021-3156-heap-based-buffer-overflow-in-sudo-baron-samedit)
