.PHONY: website
website:
	cd website && webdev build
	rm -rf public
	mkdir public
	cp -r website/build/assets/ public/assets/
	cp -r website/build/fonts/ public/fonts/
	cp website/build/favicon.ico public/
	cp website/build/index.html public/
	cp website/build/main.dart.js public/
	cp website/build/styles.css public/

.PHONY: runlocally
runlocally: website
	bundle exec ruby app.rb -p 8080

# https://cloud.google.com/appengine/docs/standard/ruby/testing-and-deploying-your-app#testing-on-app-engine
.PHONY: deploy
deploy: website
	gcloud app deploy --no-promote
	echo "New version is not yet receiving traffic. Go to https://console.cloud.google.com/appengine/versions. See help for 'gcloud app versions'"


.PHONY: clean
clean:
	rm -rf public/
