#!/bin/sh
set -e

cp $DOC_BASE_FOLDER/index.html.md /usr/src/app/source

cd /usr/src/app/source
bundle exec middleman build --verbose --clean
#Getting back to home folder to allow relative doc_base_folder
cd $GITHUB_WORKSPACE
mv /usr/src/app/build $DOC_BASE_FOLDER