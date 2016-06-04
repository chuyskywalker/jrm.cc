#!/bin/bash

docker build -t jrmcc .
docker run -ti --rm -v `pwd`:/app jrmcc
