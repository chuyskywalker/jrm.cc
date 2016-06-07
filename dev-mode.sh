#!/bin/bash

docker build -t jrmcc .
docker rm -f jrmccdev 2>/dev/null
# docker run -ti --rm --name=jrmccdev -v `pwd`:/app jrmcc
docker run -d --name=jrmccdev -v `pwd`:/app jrmcc
