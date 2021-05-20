#!/bin/sh
set -e

cat /usr/src/index.html.md > $DOC_BASE_FOLDER/index.html.md.tmp

# Grab all .md files and build them
# Exception: REAMDE file

for i in $(ls $DOC_BASE_FOLDER/*.md); do
    if [ "$i" != $DOC_BASE_FOLDER/README.md ]; then
        echo "Building $i..."
        cat $i >> $DOC_BASE_FOLDER/index.html.md.tmp;
        echo -e "\n" >> $DOC_BASE_FOLDER/index.html.md.tmp;
    fi
done;

mv $DOC_BASE_FOLDER/index.html.md.tmp $DOC_BASE_FOLDER/index.html.md
exec "$@"