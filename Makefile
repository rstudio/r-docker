BASE_IMAGE ?= rstudio/r-base
VERSIONS ?= 3.1 3.2 3.3 3.4 3.5 3.6 4.0 4.1 4.2 devel
VARIANTS ?= bionic focal jammy centos7 rockylinux8 rockylinux9 opensuse154

# PATCH_VERSIONS defines all actively maintained R patch versions.
PATCH_VERSIONS ?= 3.1.3 3.2.5 3.3.3 3.4.4 3.5.3 \
	3.6.0 3.6.1 3.6.2 3.6.3 \
	4.0.0 4.0.1 4.0.2 4.0.3 4.0.4 4.0.5 \
	4.1.0 4.1.1 4.1.2 4.1.3 4.2.0 4.2.1 4.2.2 4.2.3
# INCLUDE_PATCH_VERSIONS, if set to `yes`, includes all patch versions in the
# "all" targets.
INCLUDE_PATCH_VERSIONS ?= no

all: build-all test-all

update-all-docker:
	docker run -it --rm -v $(PWD):/r-docker -w /r-docker ubuntu:focal /r-docker/update.sh

update-all:
	@./update.sh

build-base-%:
	docker build -t $(BASE_IMAGE):$* base/$*/.

pull-base-%:
	docker pull $(BASE_IMAGE):$*

push-base-%:
	docker push $(BASE_IMAGE):$*

define GEN_R_IMAGE_TARGETS
build-$(version)-$(variant): build-base-$(variant)
	# Temporary workaround for Dockerfile caching bug with Docker BuildKit.
	# Specify Dockerfile via stdin to avoid wrong R versions from being used.
	# https://github.com/moby/buildkit/issues/1368
	cat $(version)/$(variant)/Dockerfile | docker build -t $(BASE_IMAGE):$(version)-$(variant) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--file - \
		$(version)/$(variant)/.

rebuild-$(version)-$(variant): build-base-$(variant)
	docker build --no-cache -t $(BASE_IMAGE):$(version)-$(variant) --build-arg BASE_IMAGE=$(BASE_IMAGE) $(version)/$(variant)/.

test-$(version)-$(variant):
	docker run --rm -v $(PWD)/test:/test \
		-e TAG_VERSION=$(version) \
		$(BASE_IMAGE):$(version)-$(variant) \
		bash -l /test/test.sh

bash-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test $(BASE_IMAGE):$(version)-$(variant) bash

pull-$(version)-$(variant):
	docker pull $(BASE_IMAGE):$(version)-$(variant)

push-$(version)-$(variant):
	docker push $(BASE_IMAGE):$(version)-$(variant)
	IMAGE_NAME=$(BASE_IMAGE):$(version)-$(variant) DOCKER_REPO=$(BASE_IMAGE) bash ./$(version)/$(variant)/hooks/post_push

BUILD_R_IMAGES += build-$(version)-$(variant)
REBUILD_R_IMAGES += rebuild-$(version)-$(variant)
TEST_R_IMAGES += test-$(version)-$(variant)
PULL_R_IMAGES += pull-$(version)-$(variant)
PUSH_R_IMAGES += push-$(version)-$(variant)
endef

$(foreach variant,$(VARIANTS), \
  $(foreach version,$(VERSIONS), \
    $(eval $(GEN_R_IMAGE_TARGETS)) \
  ) \
)

define minor_version
$(shell echo $(version) | cut -d. -f-2)
endef

define GEN_R_PATCH_IMAGE_TARGETS
build-$(version)-$(variant): build-base-$(variant)
	# Temporary workaround for Dockerfile caching bug with Docker BuildKit.
	# Specify Dockerfile via stdin to avoid wrong R versions from being used.
	# https://github.com/moby/buildkit/issues/1368
	cat $(minor_version)/$(variant)/Dockerfile | docker build -t $(BASE_IMAGE):$(version)-$(variant) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg R_VERSION=$(version) \
		--file - \
		$(minor_version)/$(variant)/.

rebuild-$(version)-$(variant): build-base-$(variant)
	docker build --no-cache -t $(BASE_IMAGE):$(version)-$(variant) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg R_VERSION=$(version) \
		$(minor_version)/$(variant)/.

test-$(version)-$(variant):
	docker run --rm -v $(PWD)/test:/test \
		-e TAG_VERSION=$(version) \
		$(BASE_IMAGE):$(version)-$(variant) \
		bash -l /test/test.sh

bash-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test $(BASE_IMAGE):$(version)-$(variant) bash

pull-$(version)-$(variant):
	docker pull $(BASE_IMAGE):$(version)-$(variant)

push-$(version)-$(variant):
	docker push $(BASE_IMAGE):$(version)-$(variant)

ifeq (yes,$(INCLUDE_PATCH_VERSIONS))
BUILD_R_IMAGES += build-$(version)-$(variant)
REBUILD_R_IMAGES += rebuild-$(version)-$(variant)
TEST_R_IMAGES += test-$(version)-$(variant)
PULL_R_IMAGES += pull-$(version)-$(variant)
PUSH_R_IMAGES += push-$(version)-$(variant)
endif
endef

$(foreach variant,$(VARIANTS), \
  $(foreach version,$(PATCH_VERSIONS), \
    $(eval $(GEN_R_PATCH_IMAGE_TARGETS)) \
  ) \
)

rebuild-all: $(REBUILD_R_IMAGES)

build-all: $(BUILD_R_IMAGES)

test-all: $(TEST_R_IMAGES)

pull-all: $(PULL_R_IMAGES)

push-all: $(PUSH_R_IMAGES)

print-variants:
	@echo $(VARIANTS)
