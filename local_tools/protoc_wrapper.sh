#!/bin/bash


# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---


# Required tools:
# - protoc
# - protoc-gen-dart
# - dart
export PATH="$PWD/$(rlocation local_tools/):$PATH"


output_absolute_directory="$PWD/$1"
input_file="$2"

input_file_dir="`dirname $input_file`"
input_file_name="`basename $input_file`"


mkdir -p "$output_absolute_directory"
cd "$input_file_dir" &&\
    protoc --dart_out="$output_absolute_directory" "$input_file_name"
