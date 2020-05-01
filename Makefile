BASE_IMAGE ?= rstudio/r-base
VERSIONS = 3.1 3.2 3.3 3.4 3.5 3.6 4.0
VARIANTS = xenial bionic centos6 centos7 centos8 opensuse42 opensuse15

all: build-all test-all

update-all-docker:
	docker run -it --rm -v $(PWD):/r-docker -w /r-docker ubuntu:xenial /r-docker/update.sh

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
	docker build -t $(BASE_IMAGE):$(version)-$(variant) --build-arg BASE_IMAGE=$(BASE_IMAGE) $(version)/$(variant)/.

rebuild-$(version)-$(variant): build-base-$(variant)
	docker build --no-cache -t $(BASE_IMAGE):$(version)-$(variant) --build-arg BASE_IMAGE=$(BASE_IMAGE) $(version)/$(variant)/.

test-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test $(BASE_IMAGE):$(version)-$(variant) bash -l /test/test.sh

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

rebuild-all: $(REBUILD_R_IMAGES)

build-all: $(BUILD_R_IMAGES)

test-all: $(TEST_R_IMAGES)

pull-all: $(PULL_R_IMAGES)

push-all: $(PUSH_R_IMAGES)
