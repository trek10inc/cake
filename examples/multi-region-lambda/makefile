# Multi-Region Lambda (Conditional Deployments)

include github.com/trek10inc/cake/pieces/basic/default.mk

# Quickly deploy to a list of regions defined in cake.yml
deploy-all-regions: deploy-region-list
include github.com/trek10inc/cake/pieces/deploy/region-list.mk

# Quickly destroty list of regions defined in cake.yml
destroy-all-regions: destroy-region-list
include github.com/trek10inc/cake/pieces/destroy/region-list.mk
