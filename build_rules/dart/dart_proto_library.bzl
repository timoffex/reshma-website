load(":common.bzl", "dart_package_name_from_label")
load(":dart_info.bzl", "DartInfo")
load("//build_rules/proto:proto_info.bzl", "ProtoInfo")

def _dart_proto_library_impl(ctx):
    libdir = ctx.bin_dir.path + "/" + ctx.label.package + "/generated/lib"

    generated_files = []
    for protolib in ctx.attr.deps:
        for srcfile in protolib[ProtoInfo].srcs:
            args = ctx.actions.args()

            filename = srcfile.basename.replace(".proto", "")

            pb = ctx.actions.declare_file(
                "generated/lib/" + filename + ".pb.dart",
            )
            pbenum = ctx.actions.declare_file(
                "generated/lib/" + filename + ".pbenum.dart",
            )
            pbjson = ctx.actions.declare_file(
                "generated/lib/" + filename + ".pbjson.dart",
            )
            pbserver = ctx.actions.declare_file(
                "generated/lib/" + filename + ".pbserver.dart",
            )

            compiler_outputs = [pb, pbenum, pbjson, pbserver]
            generated_files.extend(compiler_outputs)

            ctx.actions.run(
                outputs = compiler_outputs,
                inputs = [srcfile],
                executable = ctx.executable._protoc_wrapper,
                arguments = [
                    libdir,
                    srcfile.path,
                ],
            )

    dart_package_name = dart_package_name_from_label(ctx.label)
    pubspec = ctx.actions.declare_file("generated/pubspec.yaml")
    _generate_pubspec(
        ctx,
        file = pubspec,
        dart_package_name = dart_package_name,
    )
    generated_files.append(pubspec)

    synthesized_package = ctx.actions.declare_file("synthesized")
    ctx.actions.run_shell(
        outputs = [synthesized_package],
        inputs = generated_files,
        command = "cd " + synthesized_package.dirname +
                  " && ln -s generated/ synthesized",
    )

    return [
        DefaultInfo(files = depset([synthesized_package] + generated_files)),
        DartInfo(
            dart_package_name = dart_package_name,
            synthesized_package = synthesized_package,
            transitive_local_deps = depset(),
        ),
    ]

def _generate_pubspec(ctx, file, dart_package_name):
    ctx.actions.expand_template(
        output = file,
        template = ctx.file._pubspec_template,
        substitutions = {
            "{DART_PACKAGE}": dart_package_name,
        },
    )

dart_proto_library = rule(
    implementation = _dart_proto_library_impl,
    attrs = {
        "deps": attr.label_list(providers = [ProtoInfo]),
        "_pubspec_template": attr.label(
            default = ":dart_proto_pubspec.yaml.template",
            allow_single_file = True,
        ),
        "_protoc_wrapper": attr.label(
            default = "//local_tools:protoc_wrapper",
            executable = True,
            cfg = "exec",
        ),
    },
)
