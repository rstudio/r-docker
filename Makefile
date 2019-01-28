VERSION ?= 3.4
VARIANT ?= xenial

build-base:
	docker build -t rstudio/r:${VARIANT} base/${VARIANT}/.

build-r:
	docker build -t rstudio/r:${VERSION}-${VARIANT} ${VERSION}/${VARIANT}/.

.PHONY: build