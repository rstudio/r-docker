#!/usr/bin/env bash
set -ex

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

R --version
Rscript -e 'sessionInfo()'

# Ensure that the R version in the Docker tag (x.y or x.y.z) matches the image
r_ver=$(Rscript -e 'cat(as.character(getRversion()))')
if [[ "$TAG_VERSION" != "devel" ]] && [[ ! "$r_ver" =~ ^"$TAG_VERSION" ]]; then
    echo "R version $r_ver does not match Docker tag version $TAG_VERSION"
    exit 1
fi

# List R devel dependencies: C compiler, C++ compiler, Fortran compiler.
# These may differ by R version and platform, but are usually gcc, g++, gfortran.
$(R CMD config CC) --version
$(R CMD config CXX) --version
$(R CMD config FC) --version

# List shared library dependencies (e.g. BLAS/LAPACK)
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(R RHOME)/lib ldd $(R RHOME)/lib/libR.so

# Install a package with C/C++ and Fortran code, which links against libR, BLAS, LAPACK
R CMD INSTALL $DIR/testpkg --clean
Rscript $DIR/testpkg/tests/test.R

# Check that TinyTeX and Pandoc were installed correctly
tlmgr --version
echo -e '# Title\ncontent' | pandoc --output $DIR/test.pdf
rm $DIR/test.pdf

# R tests
Rscript $DIR/test.R
