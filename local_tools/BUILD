package(
    default_visibility = ["//visibility:public"],
)

sh_binary(
    name = "protoc_wrapper",
    srcs = ["protoc_wrapper.sh"],
    data = [
        "@local_tools//:dart",
        "@local_tools//:protoc",
        "@local_tools//:protoc-gen-dart",
    ],
    deps = ["@bazel_tools//tools/bash/runfiles"],
)
