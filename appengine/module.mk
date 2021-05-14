define _include
include $(subdir_src)/default/module.mk
include $(subdir_src)/editor/module.mk
endef

$(eval $(_include))
