DIST = dist/store.love

dev:
	/Applications/love.app/Contents/MacOS/love .

bundle:
	@echo "Creating distribution zip file: $(ZIP_FILE)"
	@zip -r $(DIST) . -x "*.git*" "*.zip" "Makefile" ".DS_Store"

distribute:
	@./increment_version.sh patch
	@cp VERSION dist/VERSION
	@make bundle
	@rm -rf ./api/public/*
	@cp -r dist/* ./api/public/*

.PHONY: clean package
clean:
	rm -rf dist
