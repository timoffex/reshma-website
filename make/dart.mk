# This library defines macros and functions for working with Dart
# packages.
#
# The following macros are provided:
#
#   dart_pkg
#   import_dart_pkg




# A function to declare the current directory as a Dart package.
#
# This takes the following arguments:
#
#   $1 - The Dart package name, like "rz.path.in.project"
#   $2 - The output Dart files in $(subdir_out)
#
# It creates rules for copying pubspec.yaml to the output directory,
# and it creates the following global variables:
#
#   DART_PKG_DIR/$1   - The directory containing the output Dart
#                       files (equivalent to $(subdir_out))
#
#   DART_PKG/$1       - The prerequisites to use to depend on the
#                       created Dart package.
#
# This rule does NOT create rules for $(_DART_LIB_OUTS). It is up to
# the module to define how to create its Dart files (since they may be
# generated).
#
# Usage:
#
#   $(eval $(call dart_pkg,rz.path,$(_DART_LIB_OUTS)))
#
# The current directory must contain a pubspec.yaml file.
define dart_pkg


# Ensure that pubspec.yaml exists
ifeq (,$(wildcard $(subdir_src)/pubspec.yaml))
$$(error "File $(subdir_src)/pubspec.yaml doesn't exist, can't define package")
endif


# The directory containing the Dart files
DART_PKG_DIR/$1 := $(subdir_out)

# The prerequisites for depending on this Dart package
DART_PKG/$1 := $(subdir_out)/pubspec.yaml $2


# Target for pubspec.yaml
$(subdir_out)/pubspec.yaml: $(subdir_src)/pubspec.yaml
	mkdir -p $$(dir $$@)
	cp $$< $$@


endef # dart_pkg





# A function to create a rule to import a Dart package declared with
# dart_pkg into the local_packages directory.
#
# Arguments:
#
#   $1 - The name of the package to import
#
# Usage:
#
#   $(eval $(call import_dart_pkg,rz.my_package))
#
# This defines an action called "local_packages_$1" that can be
# depended on by other rules.
define import_dart_pkg
$(call action,local_packages_$1): $(DART_PKG/$1)
	mkdir -p $(subdir_src)/local_packages/$1
	cp -a $(DART_PKG_DIR/$1)/* $(subdir_src)/local_packages/$1
	$$(touch_action)
endef
