# The output directory.
#
# This may be overridden at the commandline like so:
#
#   make target OUTPUT_DIR=...
#
# This Makefile does not define a `clean` target. Instead, by
# convention, files are only generated in the output directory, so you
# can clean up by deleting the output directory.
OUTPUT_DIR := out


################################################################################
# HELPER MACROS FOR SUBMODULES                                                 #
################################################################################
#
# Submodules are "module.mk" files in subdirectories. All submodules
# are included in this Makefile, and make is always invoked from the
# project's root directory.
#
# Modules create targets under $(OUTPUT_DIR) whose prerequisites are
# source files from the module's source directory, or other generated
# files from $(OUTPUT_DIR). By convention, modules do not touch the
# source directories of other modules. Instead, a module can "export"
# its source files to its output directory to indicate that other
# modules may depend on them.
#
# Modules can include their own submodules, but should be careful to
# not use any of the following helper macros after an include
# directive, since many of these depend on $(MAKEFILE_LIST) to work
# properly.
#
# Modules should never use variables in recipes because variables can
# be unknowingly overwritten by other modules. Instead, use automatic
# variables such as $@ and $<. Modules can define local variables by
# preceding them with an underscore, but it should be understood that
# those variables may be garbage when recipes are evaluated or after
# an include directive.


# Helper macro to get the current subdirectory in subdirectory Makefiles
# Do not use in recipes (of course)
subdirectory = $(patsubst %/module.mk,%,                                       \
                 $(word                                                        \
                   $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))


# A macro that evaluates to a submodule's SOURCE directory.
#
# The source directory should only contain handwritten, not generated,
# code.
#
# A module should not read from other modules' source directories.
# This makes module interdependencies explicit by requiring the
# dependency to declare a rule that copies source files into the
# output directory.
subdir_src = $(subdirectory)


# A macro that evaluates to a submodule's OUTPUT directory.
#
# Submodule files (module.mk) should declare targets in the output
# directory. Modules can also depend on files generated by other modules,
# but they should not depend on source code in other modules.
#
# To depend on a generated file from another module, write it as
# $(OUTPUT_DIR)/path/from/project/root/file.dart
subdir_out = $(OUTPUT_DIR)/$(subdirectory)


# A function that copies the specified files from the SOURCE directory
# to the OUTPUT directory.
#
# Usage: $(eval (call exportsrc,file1 file2 file3 ...))
define exportsrc
$(addprefix $(subdir_out)/,$1): $(subdir_out)/%: $(subdir_src)/%
	mkdir -p $$(dir $$@)
	cp $$< $$@
endef



################################################################################
# SUBMODULES                                                                   #
################################################################################


include appengine/module.mk
include website/module.mk



################################################################################
# PHONY TARGETS                                                                #
################################################################################



.PHONY: runlocally
runlocally: $(OUTPUT_DIR)/appengine/public
	cd $(OUTPUT_DIR)/appengine && \
	  bundle exec ruby app.rb -p 8080

# https://cloud.google.com/appengine/docs/standard/ruby/testing-and-deploying-your-app#testing-on-app-engine
.PHONY: deploy
deploy: $(OUTPUT_DIR)/appengine/public
	cd $(OUTPUT_DIR)/appengine && \
	  gcloud app deploy --no-promote
	@echo "New version is not yet receiving traffic. Go to https://console.cloud.google.com/appengine/versions. See help for 'gcloud app versions'"
