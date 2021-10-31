define _include
include $(subdir_src)/website/module.mk
include $(subdir_src)/editor/module.mk
endef

$(eval $(_include))
