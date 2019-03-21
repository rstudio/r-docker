BASE_IMAGE ?= rstudio/r-base
VERSIONS = 3.1 3.2 3.3 3.4 3.5
VARIANTS = xenial bionic centos6 centos7

all: build-all test-all

update-all-docker:
	docker run -it --rm -v $(PWD):/r-docker -w /r-docker ubuntu:xenial /r-docker/update.sh

update-all:
	@./update.sh

build-base-%:
	docker build -t $(BASE_IMAGE):$* base/$*/.

define GEN_BUILD_R_IMAGES
build-$(version)-$(variant): build-base-$(variant)
	docker build -t $(BASE_IMAGE):$(version)-$(variant) --build-arg BASE_IMAGE=$(BASE_IMAGE) $(version)/$(variant)/.

test-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test $(BASE_IMAGE):$(version)-$(variant) /test/test.sh

BUILD_R_IMAGES += build-$(version)-$(variant)
TEST_R_IMAGES += test-$(version)-$(variant)
endef

$(foreach variant,$(VARIANTS), \
  $(foreach version,$(VERSIONS), \
    $(eval $(GEN_BUILD_R_IMAGES)) \
  ) \
)

build-all: $(BUILD_R_IMAGES)

test-all: $(TEST_R_IMAGES)