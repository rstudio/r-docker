BASE_IMAGE ?= rstudio/r-base
VERSIONS = 3.4 3.5
VARIANTS = xenial bionic

all: update-all build-all test-all

update-all:
	@./update.sh

build-base-%:
	docker build -t $(BASE_IMAGE):$* base/$*/.

define GEN_BUILD_R_IMAGES
build-r-$(version)-$(variant): build-base-$(variant)
	docker build -t $(BASE_IMAGE):$(version)-$(variant) --build-arg BASE_IMAGE=$(BASE_IMAGE) $(version)/$(variant)/.

test-r-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test $(BASE_IMAGE):$(version)-$(variant) /test/test.sh

BUILD_R_IMAGES += build-r-$(version)-$(variant)
TEST_R_IMAGES += test-r-$(version)-$(variant)
endef

$(foreach variant,$(VARIANTS), \
  $(foreach version,$(VERSIONS), \
    $(eval $(GEN_BUILD_R_IMAGES)) \
  ) \
)

build-all: $(BUILD_R_IMAGES)

test-all: $(TEST_R_IMAGES)