BASE_IMAGE ?= posit/r-base
VERSIONS ?= 3.1 3.2 3.3 3.4 3.5 3.6 4.0 4.1 4.2 4.3 4.4 4.5 devel next
VARIANTS ?= focal jammy noble bookworm centos7 rockylinux8 rockylinux9 opensuse156

# PATCH_VERSIONS defines all actively maintained R patch versions.
PATCH_VERSIONS ?= 3.1.3 3.2.5 3.3.3 3.4.4 3.5.3 \
	3.6.0 3.6.1 3.6.2 3.6.3 \
	4.0.0 4.0.1 4.0.2 4.0.3 4.0.4 4.0.5 \
	4.1.0 4.1.1 4.1.2 4.1.3 \
	4.2.0 4.2.1 4.2.2 4.2.3 \
	4.3.0 4.3.1 4.3.2 4.3.3 \
	4.4.0 4.4.1 4.4.2 4.4.3 \
	4.5.0
# INCLUDE_PATCH_VERSIONS, if set to `yes`, includes all patch versions in the
# "all" targets.
INCLUDE_PATCH_VERSIONS ?= no

# Architecture used for the image tags, either amd64 or arm64.
# ARCH can be omitted to directly push a single arch image.
ARCH ?= $(shell arch | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')

# When set, pushes to an alternate base image (used for pushing to the deprecated rstudio/r-base).
TARGET_BASE_IMAGE ?=

all: build-all test-all

arch:
	@echo $(ARCH)

update-all-docker:
	docker run -it --rm -v $(PWD):/r-docker -w /r-docker ubuntu:noble /r-docker/update.sh

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
	docker build -t $(BASE_IMAGE):$(version)-$(variant) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
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
	BASE_IMAGE=$(BASE_IMAGE) TARGET_BASE_IMAGE=$(TARGET_BASE_IMAGE) VERSION=$(version) VARIANT=$(variant) ARCH=$(ARCH) bash ./push-images.sh

push-multiarch-$(version)-$(variant):
	BASE_IMAGE=$(BASE_IMAGE) VERSION=$(version) VARIANT=$(variant) bash ./push-multiarch.sh

BUILD_R_IMAGES += build-$(version)-$(variant)
REBUILD_R_IMAGES += rebuild-$(version)-$(variant)
TEST_R_IMAGES += test-$(version)-$(variant)
PULL_R_IMAGES += pull-$(version)-$(variant)
PUSH_R_IMAGES += push-$(version)-$(variant)
PUSH_MULTIARCH_R_IMAGES += push-multiarch-$(version)-$(variant)
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
	docker build -t $(BASE_IMAGE):$(version)-$(variant) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg R_VERSION=$(version) \
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
	BASE_IMAGE=$(BASE_IMAGE) TARGET_BASE_IMAGE=$(TARGET_BASE_IMAGE) VERSION=$(version) VARIANT=$(variant) ARCH=$(ARCH) bash ./push-images.sh

push-multiarch-$(version)-$(variant):
	BASE_IMAGE=$(BASE_IMAGE) VERSION=$(version) VARIANT=$(variant) bash ./push-multiarch.sh

ifeq (yes,$(INCLUDE_PATCH_VERSIONS))
BUILD_R_IMAGES += build-$(version)-$(variant)
REBUILD_R_IMAGES += rebuild-$(version)-$(variant)
TEST_R_IMAGES += test-$(version)-$(variant)
PULL_R_IMAGES += pull-$(version)-$(variant)
PUSH_R_IMAGES += push-$(version)-$(variant)
PUSH_MULTIARCH_R_IMAGES += push-multiarch-$(version)-$(variant)
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

push-multiarch-all: $(PUSH_MULTIARCH_R_IMAGES)

print-variants:
	@echo $(VARIANTS)
