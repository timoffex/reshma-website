load("//build_rules/private:dart.bzl", "get_dart_package_name")

def _dart_proto_library_impl(ctx):
    libdir = ctx.actions.declare_directory("lib")
    pubspec = _create_pubspec_file(ctx)
    output_files = [pubspec, libdir]

    for srcfile in ctx.files.srcs:
        args = ctx.actions.args()

        filename = srcfile.basename.replace(".proto", "")

        pb = ctx.actions.declare_file("lib/" + filename + ".pb.dart")
        pbenum = ctx.actions.declare_file("lib/" + filename + ".pbenum.dart")
        pbjson = ctx.actions.declare_file("lib/" + filename + ".pbjson.dart")
        pbserver = ctx.actions.declare_file("lib/" + filename + ".pbserver.dart")

        # I might need a separate action to create libdir if there are
        # multiple proto source files
        compiler_outputs = [libdir, pb, pbenum, pbjson, pbserver]
        output_files.extend(compiler_outputs)

        ctx.actions.run(
            outputs = compiler_outputs,
            inputs = [srcfile],
            executable = ctx.executable._protoc_wrapper,
            arguments = [
                libdir.path,
                srcfile.path,
            ],
        )

    return [DefaultInfo(files = depset(output_files))]

def _create_pubspec_file(ctx):
    file = ctx.actions.declare_file("pubspec.yaml")

    ctx.actions.expand_template(
        template = ctx.file._pubspec_template,
        output = file,
        substitutions = {
            "{DART_PACKAGE}": get_dart_package_name(ctx.label),
        },
    )

    return file

dart_proto_library = rule(
    implementation = _dart_proto_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".proto"]),
        "_protoc_wrapper": attr.label(
            default = "//local_tools:protoc_wrapper",
            executable = True,
            cfg = "exec",
        ),
        "_pubspec_template": attr.label(
            default = "//build_rules:dart_proto_pubspec.yaml.template",
            allow_single_file = True,
        ),
    },
)
