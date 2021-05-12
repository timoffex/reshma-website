$(eval $(call assert_defined, \
    DART_PKG_DIR/rz.proto \
    DART_PKG/rz.proto \
))

_IMPORTED_PACKAGES := rz.proto rz.coreweb


# Create a rule for every package in $(_IMPORTED_PACKAGES)
$(foreach P,$(_IMPORTED_PACKAGES),\
    $(eval $(call import_dart_pkg,$P)))


# Create local_packages directory and copy files into it
$(call action,local_packages): $(foreach P,$(_IMPORTED_PACKAGES),\
                                 $(call action,local_packages_$P))
	$(touch_action)


# Run "pub get" whenever pubspec.yaml updates or the local packages
# change
$(call action,pub_get): $(subdir_src)/pubspec.yaml		\
                        $(call action,local_packages)
	cd $(dir $<) && pub get
	$(touch_action)


# Run "webdev build" to build the package
$(subdir_src)/build: $(make_actions_dir)/pub_get \
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
$(subdir_src)/serve: $(make_actions_dir)/pub_get
	cd $(dir $@) && \
	  webdev serve --output web:build
