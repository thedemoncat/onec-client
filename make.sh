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
 
cp nethasp.ini nethasp.ini.bak
sed -i "s/"%HASP_SERVER%"/$HASP_SERVER/" nethasp.ini

docker build -t demoncat/onec:full-"$ONEC_VERSION" \
    -f onec-full/Dockerfile \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg ONEC_VERSION="$ONEC_VERSION" .

docker build -t demoncat/onec:client-"$ONEC_VERSION" \
    --build-arg ONEC_VERSION="$ONEC_VERSION" .

cp  nethasp.ini.bak nethasp.ini
rm -f nethasp.ini.bak