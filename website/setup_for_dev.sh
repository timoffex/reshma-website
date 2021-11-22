#!/bin/bash

WORKSPACE=$(bazel info workspace)
cd $WORKSPACE/website

bazel build website

rm pubspec.yaml local_dependencies
ln -s $WORKSPACE/bazel-bin/website/dev_pubspec.yaml pubspec.yaml
ln -s $WORKSPACE/bazel-bin/website/local_dependencies local_dependencies

dart pub get
