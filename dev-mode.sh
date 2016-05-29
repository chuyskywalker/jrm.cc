#!/bin/bash

docker build -t jrmcc .
docker run -ti --rm \
 -p 8080:8080 -p 8181:8181 \
 -v `pwd`:/app \
 -v ~/.ssh:/root/.ssh \
 -v ~/.gitconfig:/root/.gitconfig \
 jrmcc
