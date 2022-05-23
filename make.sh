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
  OLD_VERSION_DIST=19
  echo "Собираем образ с версией платформы $item"
  if [ "$(echo $item | cut -d'.' -f3)" -gt "$OLD_VERSION_DIST" ]; then
      echo "С версии 8.3.20 и выше, дистрибутив установки изенился на run. Собираем по новой схеме сборки"
    docker build -t $IMAGE_NAME:"$item" \
        --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
        --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
        --build-arg ONEC_VERSION="$item" .
  else
    echo "Ниже версии 8.3.20, используется старая версия дистрибутивов (deb пакеты). Собираем по старой схеме сборки"
    # Собираем базровый образ
    ONEC_FULL_DIR=$(pwd)/onec-full
    if [ -d "$ONEC_FULL_DIR" ]; then rm -Rf $ONEC_FULL_DIR; fi
    git clone https://github.com/TheDemonCat/onec-full.git $ONEC_FULL_DIR
    docker build -t  ghcr.io/thedemoncat/onec-full:"$ONEC_VERSION" \
        -f $(pwd)/onec-full/Dockerfile_deb \
        --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
        --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
        --build-arg ONEC_VERSION="$ONEC_VERSION" $ONEC_FULL_DIR

    docker build -t "$IMAGE_NAME":"$ONEC_VERSION" \
        --build-arg ONEC_VERSION="$ONEC_VERSION" \
        -f Dockerfile-deb .
    rm -rf $ONEC_FULL_DIR
  fi 

done

rm -f nethasp.ini
