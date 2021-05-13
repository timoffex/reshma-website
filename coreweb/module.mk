_LIB_FILES := $(shell cd $(subdir_src) && find lib -type f | grep -E '.(dart|html|scss)$$')
_LIB_OUT_FILES := $(addprefix $(subdir_out)/,$(_LIB_FILES))


# Define the Dart package
$(eval $(call dart_pkg,rz.coreweb,$(_LIB_OUT_FILES)))


# Copy the lib/ files to the output directory
$(eval $(call exportsrc,$(_LIB_FILES)))


# Run "pub get" whenever pubspec.yaml updates
$(call action,pub_get): $(subdir_src)/pubspec.yaml
	cd $(dir $<) && pub get
	$(touch_action) 


# A phony target to set up this directory for local development
.PHONY: DEV/$(subdir_src)
DEV/$(subdir_src): $(call action,pub_get)


GENERATED_SRC_FILES += $(addprefix $(subdir_src)/,\
  .makeactions \
  local_packages \
  .packages \
  .dart_tool \
)
