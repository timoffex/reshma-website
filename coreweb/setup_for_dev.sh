#!/bin/bash

WORKSPACE=$(bazel info workspace)
cd $WORKSPACE/coreweb

bazel build coreweb

rm pubspec.yaml local_dependencies
ln -s $WORKSPACE/bazel-bin/coreweb/dev_pubspec.yaml pubspec.yaml
ln -s $WORKSPACE/bazel-bin/coreweb/local_dependencies local_dependencies

dart pub get
