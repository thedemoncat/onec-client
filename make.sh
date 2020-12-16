#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

if [ ! -f .env ]; then
    echo "Please, create .env file"
    exit 1
fi

docker build -t demoncat/onec-full:"$ONEC_VERSION" \
    -f onec-full/Dockerfile \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg VERSION="$ONEC_VERSION" .

docker build -t demoncat/onec-client:"$ONEC_VERSION" \
    --build-arg VERSION="$ONEC_VERSION" .
