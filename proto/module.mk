_DART_FILES := rz_schema.pb.dart     \
	       rz_schema.pbenum.dart \
	       rz_schema.pbjson.dart     \
	       rz_schema.pbserver.dart
_DART_LIB_OUTS := $(addprefix $(subdir_out)/lib/, $(_DART_FILES))





# The directory that contains the Dart files for the rz.proto package.
DART_PKG_DIR/rz.proto := $(subdir_out)

# The prerequisites to use to depend on this Dart package
DART_PKG/rz.proto := $(subdir_out)/pubspec.yaml $(_DART_LIB_OUTS);





# pubspec.yaml file for all of the Dart targets
$(subdir_out)/pubspec.yaml: $(subdir_src)/pubspec.yaml
	mkdir -p $(dir $@)
	cp $< $@


# Warn about missing grouped-target feature (the '&:' symbol)
$(if $(findstring grouped-target,$(.FEATURES)),,\
    $(info 'grouped-target' feature not present, \
           protos may get rebuilt multiple times))


# Compile proto to Dart
$(_DART_LIB_OUTS) &: $(subdir_src)/rz_schema.proto
	mkdir -p /tmp/proto_output/
	cd $(dir $<) && protoc --dart_out=/tmp/proto_output/ $(notdir $<)
	mkdir -p $(DART_PKG_DIR/rz.proto)/lib
	cp $(addprefix /tmp/proto_output/,$(_DART_FILES)) $(DART_PKG_DIR/rz.proto)/lib
