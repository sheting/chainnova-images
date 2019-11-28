#!/bin/bash

# get version
TAG=`cat ./package.json | awk 'BEGIN{FS="\""}/"version": "(.+)",/{print $4}'`
echo "###TAG:$TAG"
# set environment
export `cat ./.env | grep DOCKER`

# params required
if [ "$DOCKER_REPO_PROJ" == "" ]; then
  echo "No DOCKER_REPO_PROJ specified." && exit 1
fi
echo "###DOCKER_REPO_PROJ:$DOCKER_REPO_PROJ"

tagged=$DOCKER_REPO_PROJ:$TAG
latest=$DOCKER_REPO_PROJ:latest

# login docker repo
sh ./images/login.sh
if [ $? != 0 ]; then
  exit 1
fi

echo '... build service image & tag'
docker-compose build --pull service
docker tag $latest $tagged
if [ $? != 0 ]; then
  echo '!!!Error: build service image failed!'
  exit 1
fi

#$1         config item
#return     value
get_config_value() {
    PATTERN='$1=='"\"$1=\""'{print $2}'
    awk "$PATTERN" .env
}

REGISTRY_AUTH_USER=$(get_config_value "REGISTRY_DEPLOY_USER")
REGISTRY_AUTH_PWD=$(get_config_value "REGISTRY_DEPLOY_PWD")

echo '... docker push'

docker push $tagged
docker push $latest
sleep 5s
docker rmi $tagged $latest