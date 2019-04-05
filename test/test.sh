#!/usr/bin/env bash
set -ex

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

R --version

# R devel dependencies
gcc --version
g++ --version
gfortran --version

# Install a package with C and Fortran code, R devel libs
R CMD INSTALL $DIR/testpkg --clean

# R tests
Rscript $DIR/test.R
