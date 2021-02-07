#!/bin/bash

pushd website

echo "Compiling website"

# Compile the AngularDart application; output will be in build/
# subfolder
webdev build


popd
pushd server


echo "Compiling server"

stack build

SERVER_BIN_PATH=server/$(stack path --dist-dir)/build/reshma-website-server-exe/reshma-website-server-exe


popd

rm -rf bin
mkdir bin

cp -r website/build/ bin/
cp $SERVER_BIN_PATH bin/
