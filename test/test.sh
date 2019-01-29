#!/usr/bin/env bash
set -ex

R --version
Rscript -e 'install.packages("R6", repos = "https://cloud.r-project.org"); library(R6)'
