# Deploy to all regions in cake.yml

deploy-region-list:
	@yq r cake.yml regions |\
	while read line; do \
		APP_REGION=$$(echo $$line | cut -c 3-); \
		$(CAKE) deploy REGION=$$APP_REGION; \
	done
