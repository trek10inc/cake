# Install Deps (yq)

# compiles the template by merging all .yml files
compile:
	@mkdir -p .build
	@COUNT=$$(find template -name \*.yml 2>/dev/null | wc -l | tr -d '[:space:]'); \
	echo "INFO: compiling $$COUNT files in templates"; \
	if [ $$COUNT == "1" ]; \
	then \
		yq r template/*.yml >> .build/template.yml; \
	else \
		FILES=$$(find template -name \*.yml | paste -sd " " -); \
		yq merge $$FILES >> .build/template.yml; \
	fi
