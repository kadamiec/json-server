PARTIALS_DIR := data/partials
OUTPUT_FILE:= data/db.json

prepare-sample-data: download-examples merge-partials

download-examples:
	@mkdir -p $(PARTIALS_DIR)
	for type in users posts todos; do \
		curl https://jsonplaceholder.typicode.com/$$type -o $(PARTIALS_DIR)/$$type.json; \
	done

merge-partials:
	@echo '{}' > $(OUTPUT_FILE) # Initialize empty JSON object
	@for file in ${PARTIALS_DIR}/*.json; do \
		filename=$$(basename $$file .json); \
		jq --arg fname $$filename --slurpfile newArray $$file '. + {($$fname): $$newArray[0]}' $(OUTPUT_FILE) > temp.json && mv temp.json $(OUTPUT_FILE); \
	done
	@echo "All JSON files have been merged into $(OUTPUT_FILE)"


build:
	docker build -t json-server .
run:
	docker run -d -p 3000:3000 --name json-server json-server

