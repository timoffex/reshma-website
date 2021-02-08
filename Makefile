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

.PHONY: deploy
deploy: website
	gcloud app deploy



.PHONY: clean
clean:
	rm -rf public/
