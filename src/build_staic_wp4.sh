#!/bin/sh

echo "### Building service start. ###"

# sh ./images/login.sh
# if [ $? != 0 ]; then
#   exit 1
# fi

NODE_ENV=development yarn
yarn build
ls -l | grep -q -E "\s+dist$"
if [[ $? != 0 ]]; then
  echo "!!!ERR: Failed to build!"
  exit 1
fi

echo "*** SUCCESS ***"
exit 0