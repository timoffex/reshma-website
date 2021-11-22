def dart_package_name_from_label(label):
    return "rz." + label.package.replace("/", ".")

def pubspec_contents(
        *,
        dart_package_name,
        pub_deps = [],
        pub_dev_deps = [],
        dartinfo_deps = []):
    content = "name: " + dart_package_name + "\n\n"
    content += "environment:\n  sdk: '>=2.10.0-0 <3.0.0'\n\n"

    content += "dependencies:\n"
    for pub_dep in pub_deps:
        content += "  " + pub_dep + "\n"
    for dep in dartinfo_deps:
        content += "  " + dep.dart_package_name + ":\n"

    content += "\ndev_dependencies:\n"
    for pub_dev_dep in pub_dev_deps:
        content += "  " + pub_dev_dep + "\n"

    return content
