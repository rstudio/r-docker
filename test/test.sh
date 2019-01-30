#!/usr/bin/env bash
set -ex

R --version

# Install a package without compilation
Rscript -e 'install.packages("R6", repos = "https://cloud.r-project.org"); library(R6)'

# Install a package with compilation
Rscript -e 'install.packages("BASIX", repos = "https://cloud.r-project.org"); library(BASIX)'