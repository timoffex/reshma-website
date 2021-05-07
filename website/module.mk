_LOCAL_FILES := \
  pubspec.yaml \
  pubspec.lock \
  $(shell cd $(subdir_src) && \
      find lib -type f | grep -E '.(dart|scss|html)$$') \
  $(shell cd $(subdir_src) && \
      find web -type f | grep -v '~$$')

$(eval $(call exportsrc, $(_LOCAL_FILES)))

$(subdir_out)/build: $(addprefix $(subdir_out)/,$(_LOCAL_FILES))
	mkdir -p $(dir $@) 
	cd $(dir $@) && \
	  pub get && \
	  webdev build --output web:build
