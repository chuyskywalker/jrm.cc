#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Give any existing container a chance to stop gracefully, and then not, and then forcefully
docker stop jrmccdev
docker rm jrmccdev 2>/dev/null
docker rm -f jrmccdev 2>/dev/null

# let'er rip!
docker run \
  -ti \
  -p 8080:8080 \
  -v $DIR/jrmcc:/src \
  --name jrmccdev \
  docker.io/hugomods/hugo:exts-non-root \
  server -p 8080
