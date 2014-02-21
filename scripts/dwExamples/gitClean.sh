#!/usr/bin/env bash

pushd eclipse.platform.releng.aggregator

 git submodule foreach git clean -f -d -x
 git submodule foreach git reset --hard HEAD
 git clean -f -d -x
 git reset --hard HEAD

 git pull 
 git submodule update --init 

popd
