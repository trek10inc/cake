# Deploy to all regions in cake.yml

deploy-region-list:
	@yq r $$(PWD)/cake.yml regions |\
	while read line; do \
		$(CAKE) deploy region=$${line:2}; \
	done