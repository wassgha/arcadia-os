DIST = dist/store.love

dev:
	/Applications/love.app/Contents/MacOS/love .

bundle:
	@echo "Creating distribution zip file: $(ZIP_FILE)"
	@zip -r $(DIST) . -x "*.git*" "*.zip" "Makefile" ".DS_Store" "dist/*" "api/*" "$(ZIP_FILE)"

distribute:
	@chmod +x ./increment_version.sh
	@chmod +x ./generate_hash.sh
	@./increment_version.sh build
	@cp VERSION dist/VERSION
	@make bundle
	@./generate_hash.sh $(DIST)
	@cp HASH dist/HASH
	@rm -rf ./api/public/*
	@cp -r dist/* ./api/public/

.PHONY: clean package
clean:
	rm -rf dist
