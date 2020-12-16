#!/bin/bash
set -eu

echo "now linting: $1"
docker run --rm -i hadolint/hadolint hadolint - < "$1"
echo "-------"


# --ignore DL3006