#!/usr/bin/env bash
set -ex

R --version

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"
Rscript $DIR/test.R