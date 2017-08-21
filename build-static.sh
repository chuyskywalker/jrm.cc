#!/bin/bash

set -e # break on error.
set -u # break on using undefined variable.

# Go to right place
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Where are we?
APP_DIR="./deploy/output"

echo "-- Clean old builds (if present)"
rm -rf ${APP_DIR}

echo "-- Build static site (hugo)"
docker run -i --rm -v `pwd`:/app chuyskywalker/hugo hugo --source="/app/jrmcc" --destination="/app/deploy/output" --baseUrl="http://jrm.cc/"

echo "-- Minify the site html"
docker run -i --rm -v `pwd`/deploy:/src chuyskywalker/node-html-minifier \
  find /src/output/ \( -iname "*.html" -or -iname "*htm" \) -exec bash -c 'echo " - {}"; html-minifier --config-file /src/html-minifier-config.json {} > {}.min; mv {}.min {}' \;

EXT="css|js|eot|svg|ttf|woff|html|htm|txt"
echo "-- Compressing (${EXT}) in ${APP_DIR}"

# fetch all source files by ${EXT} (extension) and pre-compress
find "$APP_DIR" -type f -regextype posix-extended \( -iregex ".*\.(${EXT})$" \) -print0 | while read -d '' sourceFile
do
    gzip -c9 "${sourceFile}" > "${sourceFile}.gz"
    echo " - ${sourceFile} > ${sourceFile}.gz"
done

CNAME="127.0.0.1/jrmcc:latest"

echo "-- Build deployment container ($CNAME)"
cd deploy
docker build -t $CNAME .

echo "-- Done!"
