#!/bin/bash

WORKSPACE=$(bazel info workspace)
cd $WORKSPACE/editor

bazel build editor

rm pubspec.yaml local_dependencies
ln -s $WORKSPACE/bazel-bin/editor/dev_pubspec.yaml pubspec.yaml
ln -s $WORKSPACE/bazel-bin/editor/local_dependencies local_dependencies

dart pub get
