load("//build_rules/private:dart.bzl", "get_dart_package_name")
load("//build_rules/private:file_utils.bzl", "get_relative_path")

def dart_library(
        name,
        srcs = [],
        deps = [],
        dev_deps = [],
        pub_deps = [],
        pub_dev_deps = [],
        package_prefix = "rz"):
    _dart_library_rule(
        name = name,
        srcs = srcs,
        package_prefix = package_prefix,
        deps = deps,
        dev_deps = dev_deps,
        pub_deps = pub_deps,
        pub_dev_deps = pub_dev_deps,
    )

    _local_dart_library_rule(
        name = name + "_dev",
        library = ":" + name,
    )

DartInfo = provider(
    fields = [
        # The name of the Dart package
        "dart_package_name",
        # The directory of the Dart package
        "root_directory",
        # The DartInfos of the direct dart_library deps
        "local_deps",
        # The DartInfos of the direct dart_library dev deps
        "local_dev_deps",
        # The DartInfos of all transitive dart_library dependencies (dev or not)
        "transitive_local_deps",
        # List of pub dependency strings
        "pub_deps",
        # List of pub dependency strings, for dev_dependencies
        "pub_dev_deps",
        # List of files included in the library
        "files",
    ],
)

def _local_dart_library_impl(ctx):
    dev_pubspec = ctx.actions.declare_file("dev_pubspec.yaml")

    library = ctx.attr.library[DartInfo]
    package_name = library.dart_package_name
    file_content = "name: " + package_name

    file_content += "\n\nenvironment:\n  sdk: '>=2.10.0-0 <3.0.0'"

    file_content += "\n\ndependencies:"
    for dep in library.pub_deps:
        file_content += "\n  " + dep
    for dart_dep in library.local_deps.to_list():
        file_content += "\n  " + dart_dep.dart_package_name + ":"
        file_content += "\n    path: local_dependencies/"
        file_content += dart_dep.dart_package_name

    file_content += "\n\ndev_dependencies:"
    for dep in library.pub_dev_deps:
        file_content += "\n  " + dep
    for dart_dep in library.local_dev_deps.to_list():
        file_content += "\n  " + dart_dep.dart_package_name + ":"
        file_content += "\n    path: local_dependencies/"
        file_content += dart_dep.dart_package_name

    ctx.actions.write(dev_pubspec, file_content)

    local_dependency_files = []
    for local_package in library.transitive_local_deps.to_list():
        local_dependency_files += _symlink_local_dependency(ctx, local_package)

    return [
        DefaultInfo(files = depset([dev_pubspec] + local_dependency_files)),
    ]

def _symlink_local_dependency(ctx, dartinfo):
    outputs = _create_local_pubspec(ctx, dartinfo)
    outputs += _symlink_local_files(ctx, dartinfo)

    return outputs

def _create_local_pubspec(ctx, library):
    pubspec = ctx.actions.declare_file(
        "/".join([
            "local_dependencies",
            library.dart_package_name,
            "pubspec.yaml",
        ]),
    )

    package_name = library.dart_package_name
    file_content = "name: " + package_name

    file_content += "\n\nenvironment:\n  sdk: '>=2.10.0-0 <3.0.0'"

    file_content += "\n\ndependencies:"
    for dep in library.pub_deps:
        file_content += "\n  " + dep
    for dart_dep in library.local_deps.to_list():
        file_content += "\n  " + dart_dep.dart_package_name + ":"

    file_content += "\n\ndev_dependencies:"
    for dep in library.pub_dev_deps:
        file_content += "\n  " + dep
    for dart_dep in library.local_dev_deps.to_list():
        file_content += "\n  " + dart_dep.dart_package_name + ":"

    ctx.actions.write(pubspec, file_content)

    return [pubspec]

def _symlink_local_files(ctx, library):
    package_dirname = "local_dependencies/" + library.dart_package_name + "/"

    outputs = []
    for file in library.files.to_list():
        output = ctx.actions.declare_file(
            package_dirname + get_relative_path(
                of = file.short_path,
                relative_to = library.root_directory,
            ),
        )
        ctx.actions.symlink(output = output, target_file = file)
        outputs.append(output)

    return outputs

def _dart_library_impl(ctx):
    dart_package_name = get_dart_package_name(
        ctx.label,
        ctx.attr.package_prefix,
    )

    local_deps_by_package = dict()
    for dep in ctx.attr.deps:
        _merge_insert_dart_library(local_deps_by_package, dep[DartInfo])
    local_deps_direct = []
    for (_, dep) in local_deps_by_package.items():
        local_deps_direct.append(dep)
    local_deps = depset(local_deps_direct)

    local_dev_deps_by_package = dict()
    for dep in ctx.attr.dev_deps:
        _merge_insert_dart_library(local_dev_deps_by_package, dep[DartInfo])
    local_dev_deps_direct = []
    for (_, dep) in local_dev_deps_by_package.items():
        local_dev_deps_direct.append(dep)
    local_dev_deps = depset(local_dev_deps_direct)

    transitive_local_deps = depset(
        transitive = [
            dep[DartInfo].transitive_local_deps
            for dep in ctx.attr.deps + ctx.attr.dev_deps
        ] + [local_deps, local_dev_deps],
    )

    pub_deps = ctx.attr.pub_deps
    pub_dev_deps = ctx.attr.pub_dev_deps
    files = depset(ctx.files.srcs)

    return [
        DartInfo(
            dart_package_name = dart_package_name,
            root_directory = ctx.label.package,
            local_deps = local_deps,
            local_dev_deps = local_dev_deps,
            transitive_local_deps = transitive_local_deps,
            pub_deps = pub_deps,
            pub_dev_deps = pub_dev_deps,
            files = files,
        ),
    ]

def _merge_insert_dart_library(dartinfos_by_name, newinfo):
    """Inserts a DartInfo into a dict mapping package names to DartInfos.

    If there already exists a DartInfo for the same Dart package, the new one
    is merged with it.
    """
    package_name = newinfo.dart_package_name
    if package_name in dartinfos_by_name:
        oldinfo = dartinfos_by_name[package_name]
        dartinfos_by_name[package_name] = _merge_dart_libraries(
            oldinfo,
            newinfo,
        )
    else:
        dartinfos_by_name[package_name] = newinfo

def _merge_dart_libraries(info1, info2):
    if info1.root_directory != info2.root_directory:
        fail("Dart packages with the same name (" + info1.dart_package_name +
             ") must be declared in the same Bazel package, but got two" +
             "different ones: " + info1.root_directory + " vs " +
             info2.root_directory)
    return DartInfo(
        dart_package_name = info1.dart_package_name,
        root_directory = info1.root_directory,
        local_deps = depset(transitive = [info1.local_deps, info2.local_deps]),
        local_dev_deps = depset(transitive = [
            info1.local_dev_deps,
            info2.local_dev_deps,
        ]),
        pub_deps = _merge_pub_strings(info1.pub_deps, info2.pub_deps),
        pub_dev_deps = _merge_pub_strings(
            info1.pub_dev_deps,
            info2.pub_dev_deps,
        ),
        files = depset(transitive = [info1.files, info2.files]),
    )

def _merge_pub_strings(pub1, pub2):
    seen = dict()
    versions = dict()

    for dep in pub1 + pub2:
        [name, version] = dep.split(":")
        name = name.trim()
        version = version.trim()
        if name in seen:
            if versions[name] != version:
                fail("Different versions for package " +
                     name + ": '" + versions[name] + "'" +
                     " vs '" + version + "'")
        else:
            seen[name] = True
            versions[name] = version

    merged = []
    for name in seen:
        merged.append(name + ": " + versions[name])
    return merged

_dart_library_rule = rule(
    implementation = _dart_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "package_prefix": attr.string(default = "rz"),
        "deps": attr.label_list(providers = [DartInfo]),
        "dev_deps": attr.label_list(providers = [DartInfo]),
        "pub_deps": attr.string_list(),
        "pub_dev_deps": attr.string_list(),
    },
)

_local_dart_library_rule = rule(
    implementation = _local_dart_library_impl,
    attrs = {
        "library": attr.label(providers = [DartInfo]),
    },
)
