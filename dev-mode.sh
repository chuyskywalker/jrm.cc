#!/bin/bash

docker build -t jrmcc .
docker run -ti --rm --name=jrmccdev -v `pwd`:/app jrmcc
