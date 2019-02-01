#!/usr/bin/env bash
set -e

R --version

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"
Rscript $DIR/test.R