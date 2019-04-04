#!/usr/bin/env bash
set -ex

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

R --version

# R devel dependencies
gcc --version
g++ --version
gfortran --version

# R tests
Rscript $DIR/test.R
