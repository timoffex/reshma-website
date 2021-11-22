load(":proto_info.bzl", "ProtoInfo")

def _proto_library_impl(ctx):
    return [ProtoInfo(srcs = ctx.files.srcs)]

proto_library = rule(
    implementation = _proto_library_impl,
    attrs = {"srcs": attr.label_list(allow_files = True)},
)
