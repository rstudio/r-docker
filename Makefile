VERSIONS := 3.4 3.5
VARIANTS := xenial bionic

all: build-all

build-base-%:
	docker build -t rstudio/r:$* base/$*/.

define GEN_BUILD_R_IMAGES
build-r-$(version)-$(variant): build-base-$(variant)
	docker build -t rstudio/r:$(version)-$(variant) $(version)/$(variant)/.

BUILD_R_IMAGES += build-r-$(version)-$(variant)
endef

$(foreach variant,$(VARIANTS), \
  $(foreach version,$(VERSIONS), \
    $(eval $(GEN_BUILD_R_IMAGES)) \
  ) \
)

build-all: $(BUILD_R_IMAGES)