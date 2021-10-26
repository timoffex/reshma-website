_LOCAL_FILES := \
    app.yaml            \
    .gcloudignore       \
    Gemfile             \
    Gemfile.lock        \
    config.ru           \
    app.rb

_OUT_FILES := $(addprefix $(subdir_out)/,$(_LOCAL_FILES))

$(eval $(call exportsrc,$(_LOCAL_FILES)))

$(subdir_src)/Gemfile.lock: $(subdir_src)/Gemfile
	cd $(dir $@) && bundle lock

$(subdir_out)/public: $(OUTPUT_DIR)/editor/build $(_OUT_FILES)
	rm -rf $@
	mkdir -p $@
	cp -r $</assets/ $@/assets/
	cp -r $</fonts/ $@/fonts/
	cp -r $</packages/ $@/packages/
	cp $</favicon.ico $@
	cp $</index.html $@
	cp $</main.dart.js $@
	cp $</styles.css $@


.PHONY: $(subdir_src)/runlocally
$(subdir_src)/runlocally: $(subdir_out)/public
	cd $(dir $<) && \
	  bundle exec ruby app.rb -p 8080

# https://cloud.google.com/appengine/docs/standard/ruby/testing-and-deploying-your-app#testing-on-app-engine
.PHONY: $(subdir_src)/deploy
$(subdir_src)/deploy: $(subdir_out)/public
	cd $(dir $<) && \
	  gcloud app deploy --no-promote
	@echo "New version is not yet receiving traffic. Go to https://console.cloud.google.com/appengine/versions. See help for 'gcloud app versions'"
