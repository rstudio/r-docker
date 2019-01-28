OS_IDENTIFIER ?= xenial
R_VERSION ?= 3.4.4

build:
	docker build -t rstudio/r:${R_VERSION}-${OS_IDENTIFIER} --build-arg R_VERSION=${R_VERSION} ${OS_IDENTIFIER}/.

.PHONY: build