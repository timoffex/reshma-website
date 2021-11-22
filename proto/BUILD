load("//build_rules:proto.bzl", "proto_library")
load("//build_rules:dart.bzl", "dart_proto_library")

package(
    default_visibility = ["//visibility:public"],
)

proto_library(
    name = "rz_schema_proto",
    srcs = ["rz_schema.proto"],
)

dart_proto_library(
    name = "rz_schema_dart_proto",
    deps = [":rz_schema_proto"],
)
