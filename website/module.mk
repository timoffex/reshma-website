_LOCAL_FILES := \
  pubspec.yaml \
  pubspec.lock \
  $(shell cd $(subdir_src) && \
      find lib -type f | grep -E '.(dart|scss|html)$$') \
  $(shell cd $(subdir_src) && \
      find web -type f | grep -v '~$$')


# List of directores beneath $(OUTPUT_DIR) which to copy into
# local_packages/
_IMPORTED_PACKAGES := proto



# Copy all local files into the output directory for use by webdev
$(eval $(call exportsrc, $(_LOCAL_FILES)))
_OUT_FILES := $(addprefix $(subdir_out)/,$(_LOCAL_FILES))


# Copy all imported packages
_LOCAL_PACKAGES :=

define _make_local_package_rule
_LOCAL_PACKAGES += $(subdir_out)/local_packages/$1
$(subdir_src)/local_packages/$1: \
  $(OUTPUT_DIR)/$1/pubspec.yaml \
  $(wildcard $(OUTPUT_DIR)/$1/lib/*.dart)
	mkdir -p $$@/lib/
	cp $(OUTPUT_DIR)/$1/pubspec.yaml $$@/
	cp $(OUTPUT_DIR)/$1/lib/*.dart $$@/lib/
$(subdir_out)/local_packages/$1: $(subdir_src)/local_packages/$1
	mkdir -p $$@
	cp -r $$</* $$@
endef

$(foreach P,$(_IMPORTED_PACKAGES),\
  $(eval $(call _make_local_package_rule,$P)))


# Call webdev to produce the "build" directory
$(subdir_out)/build: $(_OUT_FILES) $(_LOCAL_PACKAGES)
	mkdir -p $(dir $@) 
	cd $(dir $@) && \
	  pub get && \
	  webdev build --output web:build
