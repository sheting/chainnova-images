#!/bin/bash

# $1 Optional. ENV suffix like 'preview', 'development', or ''
env=''
if [ "$1" ]
then
  env=-$1
fi

docker-compose build --pull build$env
if [ "$exitcode" != "0" ]
then
  exit $exitcode
fi