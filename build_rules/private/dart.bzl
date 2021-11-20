def get_dart_package_name(label, package_prefix = "rz"):
    return package_prefix + "." + label.package.replace("/", ".")
