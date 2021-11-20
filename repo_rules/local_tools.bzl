def _setup_local_tools_impl(repository_ctx):
    exported_files = []

    repository_ctx.symlink(
        repository_ctx.which("dart"),
        "dart",
    )
    exported_files.append("dart")

    repository_ctx.symlink(
        repository_ctx.which("protoc"),
        "protoc",
    )
    exported_files.append("protoc")

    repository_ctx.symlink(
        repository_ctx.which("protoc-gen-dart"),
        "protoc-gen-dart",
    )
    exported_files.append("protoc-gen-dart")


    exported_file_strings = []
    for f in exported_files:
        exported_file_strings.append("\"" + f + "\"")
    build_file = "exports_files([" + ", ".join(exported_file_strings) + "])"
    repository_ctx.file("BUILD", build_file)

def _filegroup(name, file):
    return """
filegroup(
    name = "{name}",
    srcs = ["{file}"],
)
""".format(name = name, file = file)

_setup_local_tools_rule = repository_rule(
    implementation = _setup_local_tools_impl,
    environ = ["PATH"],
    configure = True,
    doc = "Generates a repository with symlinks to locally installed binaries",
)

def setup_local_tools():
    _setup_local_tools_rule(name = "local_tools")
