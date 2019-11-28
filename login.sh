#!/bin/bash
# default conf
export `cat ./.env`

REPO_TYPE=$DOCKER_REPO_TYPE

echo '... docker repo login'
if [ "$REPO_TYPE" == "" ]; then
  echo "No REPO_TYPE specified." && exit 1
elif [ "$REPO_TYPE" == "ecr" ]; then
  $(aws ecr get-login --no-include-email --region cn-north-1)
  if [ $? != 0 ]; then
    echo "!!!Error: Login $REPO_TYPE failed." && exit 1
  fi
elif [ "$REPO_TYPE" == "registry" ]; then
  REGISTRY_URL=$REGISTRY_URL
  REGISTRY_AUTH_USER=$REGISTRY_DEPLOY_USER
  REGISTRY_AUTH_PWD=$REGISTRY_DEPLOY_PWD
  docker login -u $REGISTRY_AUTH_USER -p $REGISTRY_AUTH_PWD $REGISTRY_URL
  if [ $? != 0 ]; then
    echo "!!!Error: Login $REPO_TYPE failed." && exit 1
  fi
fi

echo "... DOCKER REPO LOGIN SUCCESS!"

exit 0