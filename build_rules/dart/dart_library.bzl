load("@bazel_skylib//lib:paths.bzl", "paths")
load(":common.bzl", "dart_package_name_from_label", "pubspec_contents")
load(":dart_info.bzl", "DartInfo")

def _dart_library_impl(ctx):
    dart_package_name = dart_package_name_from_label(ctx.label)
    dir = "package/"

    local_package_files = []

    pubspec = ctx.actions.declare_file(paths.join(dir, "pubspec.yaml"))
    _create_pubspec(
        ctx,
        output_file = pubspec,
        dart_package_name = dart_package_name,
    )
    local_package_files.append(pubspec)

    for file in ctx.files.srcs:
        file_path_in_package = paths.relativize(
            file.short_path,
            ctx.label.package,
        )
        output_path = paths.join(dir, file_path_in_package)
        output_file = ctx.actions.declare_file(output_path)
        ctx.actions.symlink(
            output = output_file,
            target_file = file,
        )

        local_package_files.append(output_file)

    synthesized_package = ctx.actions.declare_file("synthesized")
    ctx.actions.run_shell(
        outputs = [synthesized_package],
        inputs = local_package_files,
        command = "cd " + synthesized_package.dirname + " && " +
                  "ln -s package/ synthesized",
    )

    dev_files = _create_dev_files(ctx, dart_package_name)

    return [
        DefaultInfo(files = dev_files),
        DartInfo(
            dart_package_name = dart_package_name,
            synthesized_package = synthesized_package,
            transitive_local_deps = depset(
                [dep[DartInfo] for dep in ctx.attr.deps],
                transitive = [
                    dep[DartInfo].transitive_local_deps
                    for dep in ctx.attr.deps
                ],
            ),
        ),
    ]

def _create_pubspec(ctx, output_file, dart_package_name):
    ctx.actions.write(output = output_file, content = pubspec_contents(
        dart_package_name = dart_package_name,
        pub_deps = ctx.attr.pub_deps,
        pub_dev_deps = ctx.attr.pub_dev_deps,
        dartinfo_deps = [dep[DartInfo] for dep in ctx.attr.deps],
    ))

def _create_dev_files(ctx, dart_package_name):
    dev_pubspec = ctx.actions.declare_file("dev_pubspec.yaml")
    dev_pubspec_content = pubspec_contents(
        dart_package_name = dart_package_name,
        pub_deps = ctx.attr.pub_deps,
        pub_dev_deps = ctx.attr.pub_dev_deps,
        dartinfo_deps = [dep[DartInfo] for dep in ctx.attr.deps],
    )

    dev_pubspec_content += "\ndependency_overrides:\n"

    local_deps = depset(
        [dep[DartInfo] for dep in ctx.attr.deps],
        transitive = [
            dep[DartInfo].transitive_local_deps
            for dep in ctx.attr.deps
        ],
    )

    dev_files = [dev_pubspec]
    for dep in local_deps.to_list():
        output_dir = "local_dependencies/" + dep.dart_package_name
        output_file = ctx.actions.declare_file(output_dir)
        dev_files.append(output_file)

        # Symlink dep's synthesized package
        ctx.actions.symlink(
            output = output_file,
            target_file = dep.synthesized_package,
        )

        # Add a dependency override
        dev_pubspec_content += "  " + dep.dart_package_name + ":\n"
        dev_pubspec_content += "    path: " + output_dir + "\n"

    ctx.actions.write(output = dev_pubspec, content = dev_pubspec_content)

    return depset(dev_files)

dart_library = rule(
    implementation = _dart_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [DartInfo]),
        "pub_deps": attr.string_list(default = []),
        "pub_dev_deps": attr.string_list(default = []),
    },
)
