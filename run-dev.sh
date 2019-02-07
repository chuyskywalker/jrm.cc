#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/dev

# Rebuild (if needed, usually cached)
docker build -t jrmcc .

# Give any existing container a chance to stop gracefully, and then not, and then forcefully
docker stop jrmccdev
docker rm jrmccdev 2>/dev/null
docker rm -f jrmccdev 2>/dev/null

# Start up the latest and greatest
docker run -d --name=jrmccdev -v `pwd`/../:/app -p 81:81 jrmcc
