load("//build_rules:dart_library.bzl", "dart_library")

package(
    default_visibility = ["//visibility:public"],
)

dart_library(
    name = "coreweb",
    srcs = glob(["lib/**"]),
    pub_deps = [
        "angular: ^6.0.1",
        "angular_components: ^1.0.2",
        "bootstrap_sass: any",
        "built_collection: any",
        "sass_builder: ^2.1.3",
        "stream_transform: ^1.2.0",
    ],
    pub_dev_deps = [
        "build_runner: ^1.10.0",
        "build_web_compilers: ^2.11.0",
        "pedantic: ^1.9.0",
    ],
)
