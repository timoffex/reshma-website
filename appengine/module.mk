_LOCAL_FILES := \
    app.yaml            \
    .gcloudignore       \
    Gemfile             \
    Gemfile.lock        \
    config.ru           \
    app.rb

_OUT_FILES := $(addprefix $(subdir_out)/,$(_LOCAL_FILES))

$(eval $(call exportsrc,$(_LOCAL_FILES)))

$(subdir_out)/public: $(OUTPUT_DIR)/website/build $(_OUT_FILES)
	rm -rf $@
	mkdir -p $@
	cp -r $</assets/ $@/assets/
	cp -r $</fonts/ $@/fonts/
	cp $</favicon.ico $@
	cp $</index.html $@
	cp $</main.dart.js $@
	cp $</styles.css $@
