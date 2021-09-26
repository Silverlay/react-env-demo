ifneq (,$(wildcard ./.env))
    include .env
    export
endif
current_dir := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

IMAGE = demo/react-env

.PHONY: build test

build:
	@docker build -t $(IMAGE):latest -f ./Dockerfile --no-cache .
test:
	docker run -it -p 8080:80 \
	-e HTML_TEMPLATE=/usr/share/nginx/html/index.html \
	-e WEB_URL=/ \
	-e WEB_DEFAULT_ADMIN=test \
	-e WEB_PORTAL_URL=/portal \
	-e WEB_NUM_ERRORS=4 \
	-v $(current_dir)test:/usr/share/nginx/html \
	$(IMAGE):latest nginx -g 'daemon off;'