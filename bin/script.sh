#!/bin/sh

cd /usr/src/app/source 

if [[ "$IS_EXTERNAL" == "true" ]]; then
    mv index.html.external.md index.html.md
    rm index.html.internal.md
else
    mv index.html.internal.md index.html.md
    rm index.html.external.md
fi

bundle exec middleman build --clean

#Getting back to home folder 
cd $GITHUB_WORKSPACE
mv /usr/src/app/build build