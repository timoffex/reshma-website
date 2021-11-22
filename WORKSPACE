#------------------------------------------------------------------------------#
# Symlink required tools (as a stopgap alternative to specifying how to        #
# download or build them)                                                      #
#------------------------------------------------------------------------------#
load("//repo_rules:local_tools.bzl", "setup_local_tools")

setup_local_tools()

#------------------------------------------------------------------------------#
# Load skylib (library of common functions)                                    #
#------------------------------------------------------------------------------#
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()
