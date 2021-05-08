_LOCAL_PROTOS := rz_schema.proto


# Produces .dart filenames from the .proto file
#
# You can figure these out by running the protoc command manually and
# examining the output
_dart_outs = \
  $(foreach S,pb pbenum pbjson pbserver,$(basename $1).$S.dart)


# Produces a rule to build Dart targets from a proto file, and also
# adds those files as prerequisites for the pubspec.yaml file
define _make_dart_rule
$(call _dart_outs,$(subdir_out)/lib/$1) &: $(subdir_src)/$1
	mkdir -p $$(dir $$@)
	protoc --dart_out=$(OUTPUT_DIR) $$<
	mkdir -p $(subdir_out)/lib
	mv $(call _dart_outs,$(subdir_out)/$1) $(subdir_out)/lib/
$(subdir_out)/pubspec.yaml: $(call _dart_outs,$(subdir_out)/lib/$1)
endef


# pubspec.yaml file for all of the Dart targets
$(subdir_out)/pubspec.yaml: $(subdir_src)/pubspec.yaml
	mkdir -p $(dir $@)
	cp $< $@

# Make Dart targets for every proto
$(foreach F,$(_LOCAL_PROTOS),$(eval $(call _make_dart_rule,$F)))
