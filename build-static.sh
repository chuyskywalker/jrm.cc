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
#docker run -ti --rm -v `pwd`/deploy/output:/src chuyskywalker/minify minify --verbose --recursive --html-keep-whitespace /src

# Pre-compress gzip everything
compressResource() {
    # gzip each file and give timestamp identical to that of the uncompressed source file
    gzip -c9 "${1}" > "${1}.gz"
    touch -c --reference="${1}" "${1}.gz"
    echo "Compressed: ${1} > ${1}.gz"
}

EXT="css|js|eot|svg|ttf|woff|html|htm"
echo "Compressing (${EXT}) in ${APP_DIR}"

# fetch all source files by ${EXT} (extension) and pre-compress
find "$APP_DIR" -type f -regextype posix-extended \( -iregex ".*\.(${EXT})$" \) -print0 | while read -d '' sourceFile
do
    if [[ -f "${sourceFile}.gz" ]]; then
        # only re-gzip if source file is different in timestamp to the existing gzip file
        if [[ (${sourceFile} -nt "${sourceFile}.gz") || (${sourceFile} -ot "${sourceFile}.gz") ]]; then
            # re-compress
            compressResource "${sourceFile}"
        else
            echo "IsCompressed: ${sourceFile}"
        fi
    else
        compressResource "${sourceFile}"
    fi
done

# Build container
cd deploy
docker build -t jrmcc .

echo "Container built!"
