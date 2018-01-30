# Destroy to all regions in cake.yml

destroy-region-list:
	@yq r cake.yml regions |\
	while read line; do \
		APP_REGION=$$(echo $$line | cut -c 3-); \
		$(CAKE) destroy REGION=$$APP_REGION; \
	done
