#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

if [ ! -f .env ]; then
    echo "Please, create .env file"
    exit 1
fi

if [ -z "$HASP_SERVER" ]; then
  HASP_SERVER=localhost
fi

IMAGE_NAME=${1:-"ghcr.io/thedemoncat/onec-client"}

cp config/nethasp.ini nethasp.ini
sed -i "s/"%HASP_SERVER%"/$HASP_SERVER/" nethasp.ini

env=()
while IFS= read -r line || [[ "$line" ]]; do
  env+=("$line")
done < ONEC_VERSION

for item in ${env[*]}
do
    docker build -t  ghcr.io/thedemoncat/onec-full:"$ONEC_VERSION" \
        -f onec-full/Dockerfile \
        --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
        --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
        --build-arg ONEC_VERSION="$ONEC_VERSION" .

    docker build -t "$IMAGE_NAME":"$ONEC_VERSION" \
        --build-arg ONEC_VERSION="$ONEC_VERSION" .

done

rm -f nethasp.ini
