# Destroy to all regions in cake.yml

destroy-region-list:
	@yq r $$(PWD)/cake.yml regions |\
	while read line; do \
		$(CAKE) destroy region=$${line:2}; \
	done
