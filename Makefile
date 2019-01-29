VERSIONS := 3.4 3.5
VARIANTS := xenial bionic

all: build-all test-all

build-base-%:
	docker build -t rstudio/r:$* base/$*/.

define GEN_BUILD_R_IMAGES
build-r-$(version)-$(variant): build-base-$(variant)
	docker build -t rstudio/r:$(version)-$(variant) $(version)/$(variant)/.

test-r-$(version)-$(variant):
	docker run -it --rm -v $(PWD)/test:/test rstudio/r:$(version)-$(variant) /test/test.sh

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