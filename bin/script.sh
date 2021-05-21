#!/bin/sh

IS_EXTERNAL=$1
echo "Are we deploying externally: $IS_EXTERNAL"

cd /usr/src/app/source && bundle exec middleman build --clean

#Getting back to home folder 
cd $GITHUB_WORKSPACE
mv /usr/src/app/build build