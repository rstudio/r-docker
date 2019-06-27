#!/usr/bin/env bash
set -ex

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

R --version
Rscript -e 'sessionInfo()'

# List R devel dependencies
gcc --version
g++ --version
gfortran --version

# List shared library dependencies (e.g. BLAS/LAPACK)
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(R RHOME)/lib ldd $(R RHOME)/lib/libR.so

# Install a package with C and Fortran code, R devel libs
R CMD INSTALL $DIR/testpkg --clean

# R tests
Rscript $DIR/test.R
