#!/bin/bash

# creates a revision list, that can be used for codeface configuration files, from a cppStats output directory

# save start folder
START=${PWD}
SCRIPTDIR="$( cd -P "$( dirname "$0" )" && pwd )"

REVS="revisions: [ "

# foreach system's version, append its version number 
FOLDERS=`find $START -mindepth 1 -maxdepth 1  -type d ! -name ".*" | sort -V`
for DIR in ${FOLDERS}; do
  NAME=$(basename "${DIR}")
  REV=`echo $NAME | grep -oP "[0-9.]+$"`
  REVS+="\"$REV\", "
done

# cut last comma
REVS=${REVS%??}
REVS+=" ]"
echo $REVS
