#!/bin/bash

set -e # break on error.
set -u # break on using undefined variable.

# Go to right place
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Where are we?
APP_DIR="./deploy/output"

# Remove any existing output
rm -rf ${APP_DIR}

# Build static site
docker run -ti --rm -v `pwd`:/app chuyskywalker/hugo hugo --source="/app/jrmcc" --destination="/app/deploy/output" --baseUrl="http://jrm.cc/"

# Minify it all
#  -- Ofline till the <pre><code>whitespace muckery gets fixed up later:
#     https://github.com/tdewolff/minify/issues/82
#docker run -ti --rm -v `pwd`/deploy/output:/src chuyskywalker/minify minify --verbose --recursive --html-keep-whitespace /src

# Minify the HTML (grunt already did CSS)
docker run -ti --rm -v `pwd`/deploy:/src chuyskywalker/node-html-minifier \
  find /src/output/ \( -iname "*.html" -or -iname "*htm" \) -exec bash -x -c 'html-minifier --config-file /src/html-minifier-config.json {} > {}.min; mv {}.min {}' \;

EXT="css|js|eot|svg|ttf|woff|html|htm"
echo "Compressing (${EXT}) in ${APP_DIR}"

# fetch all source files by ${EXT} (extension) and pre-compress
find "$APP_DIR" -type f -regextype posix-extended \( -iregex ".*\.(${EXT})$" \) -print0 | while read -d '' sourceFile
do
    gzip -c9 "${sourceFile}" > "${sourceFile}.gz"
    echo "Compressed: ${sourceFile} > ${sourceFile}.gz"
done

ID=$(git rev-parse --short=12 HEAD)

CNAME="jrmcc:$ID"

# Build container
cd deploy
docker build -t $CNAME .

# docker push $CNAME

echo "Container built as $CNAME"
