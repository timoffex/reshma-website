$(eval $(call assert_defined, \
    DART_PKG_DIR/rz.proto \
    DART_PKG/rz.proto \
))

_IMPORTED_PACKAGES := rz.proto


_MAKE_ACTIONS := $(subdir_src)/.makeactions


# Function that takes the name of a local Dart package and produces a
# rule to copy it into the local_packages directory.
define _make_local_package_rule
$(_MAKE_ACTIONS)/local_packages_$1: $(DART_PKG/$1)
	mkdir -p $(subdir_src)/local_packages/$1
	cp -a $(DART_PKG_DIR/$1)/* $(subdir_src)/local_packages/$1
	mkdir -p $$(dir $$@) && touch $$@
endef


# Create a rule for every package in $(_IMPORTED_PACKAGES)
$(foreach P,$(_IMPORTED_PACKAGES),\
    $(eval $(call _make_local_package_rule,$P)))


# Create local_packages directory and copy files into it
$(_MAKE_ACTIONS)/local_packages: $(addprefix		\
		$(_MAKE_ACTIONS)/local_packages_,	\
		$(_IMPORTED_PACKAGES))
	mkdir -p $(dir $@) && touch $@


# Run "pub get" whenever pubspec.yaml updates or the local packages
# change
$(_MAKE_ACTIONS)/pub_get: $(subdir_src)/pubspec.yaml		\
                          $(_MAKE_ACTIONS)/local_packages
	cd $(subst .makeactions/pub_get,,$@) && \
	  pub get
	mkdir -p $(dir $@) && touch $@


# Run "webdev build" to build the package
$(subdir_src)/build: $(_MAKE_ACTIONS)/pub_get \
                     $(subdir_src)/lib \
                     $(subdir_src)/web
	cd $(dir $@) && \
	  webdev build --output web:build


# Copy the build directory to the output files so that it can be used
# by other rules
$(subdir_out)/build: $(subdir_src)/build
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	cp -a $< $(dir $@)


.PHONY: $(subdir_src)/serve
$(subdir_src)/serve: $(_MAKE_ACTIONS)/pub_get
	cd $(dir $@) && \
	  webdev serve --output web:build
