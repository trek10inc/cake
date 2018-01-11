CAKE := mmake
STACK_NAME := $(shell yq r cake.yml stack)

build: clean pre-transform compile

# removes any build and packaging artifacts
clean:
	@echo "INFO: cleaning old artificts"
	@rm -rf .build .packaged
.PHONY: clean

include github.com/trek10inc/cake/pieces/compile/default.mk

# compiles and validates the template
validate: build
	@echo "INFO: validating built template"
	@aws cloudformation validate-template --template-body file:///$$PWD/.build/template.yml
	@echo "INFO: template is valid"

# watches all files, rebuilds, and validates on change
watch:
	@echo "INFO: watching templates/* for changes"
	@fswatch -o template | xargs -n1 -I{} $(CAKE) validate

# pre-ransform pipeline
#
# header: Adds header info about cake / datetime
pre-transform: pre-transform-header
include github.com/trek10inc/cake/pieces/pre-transforms/header.mk

# post-transform pipeline
#
# timestamp: appends the timestamp at end of generated template
# post-transform: transform_timestamp
# include cake/pieces/post-transforms/timestamp.mk

# Simple deploy or update (args: region=)
deploy: deploy-basic
include github.com/trek10inc/cake/pieces/deploy/basic.mk
