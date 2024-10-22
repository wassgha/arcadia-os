DIST = store.love

dev:
	/Applications/love.app/Contents/MacOS/love .

distribute:
	@echo "Creating distribution zip file: $(ZIP_FILE)"
	@zip -r $(DIST) . -x "*.git*" "*.zip" "Makefile" ".DS_Store"

.PHONY: clean package
clean:
	rm -rf dist
