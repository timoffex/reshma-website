# List all files that are used to create the build/ directory.
SRC_FILES := pubspec.yaml pubspec.lock

# All Dart/Sass/HTML source files under lib/.
SRC_FILES += ${shell find lib -type f | grep -E "\.dart$$|\.scss$$|\.html$$"}

# All files under web/ excluding Emacs backups.
SRC_FILES += ${shell find web | grep -v "~$$"}


build: ${SRC_FILES}
	webdev build


.PHONY: clean
clean:
	rm -rf build/
