# Simple deploy / update

AWS_ACCOUNT := $(shell aws sts get-caller-identity --output text --query 'Account')

deploy-basic: check-create-deployment-bucket
	@mkdir -p .packaged
	@aws cloudformation package --region $(REGION) \
			 --s3-bucket $(AWS_ACCOUNT)-cloudformation-packages-$(REGION) \
			 --s3-prefix $(STACK_NAME) \
			 --template-file .build/template.yml \
			 --output-template-file .packaged/template.yml > /dev/null; \
	if [ -e params.yml ]; then \
		PARAMS=$$(cat params.yml | tr '\n' ' ' | sed -e 's/\: /=/g'); \
	fi; \
	if aws cloudformation describe-stacks \
					--stack-name $(STACK_NAME) \
					--region $(REGION) > /dev/null 2>&1; \
	then \
	  echo "INFO: stack found $(REGION).$(STACK_NAME)"; \
	  echo "INFO: stack updating $(REGION).$(STACK_NAME)"; \
		aws cloudformation deploy \
				--stack-name $(STACK_NAME) \
				--template-file .packaged/template.yml \
				--region $(REGION) \
				--parameter-overrides $$PARAMS \
				--capabilities CAPABILITY_IAM |\
		while read line; do \
			echo "INFO: $$line"; \
		done \
	else \
	  echo "INFO: stack not found $(REGION).$(STACK_NAME)"; \
	  echo "INFO: stack creating $(REGION).$(STACK_NAME)"; \
		aws cloudformation deploy \
				--stack-name $(STACK_NAME) \
				--template-file .packaged/template.yml \
				--region $(REGION) \
				--parameter-overrides $$PARAMS \
				--capabilities CAPABILITY_IAM |\
		while read line; do \
			echo "INFO: $$line"; \
		done \
	fi

check-create-deployment-bucket:
	@if aws s3 ls s3://$(AWS_ACCOUNT)-cloudformation-packages-$(REGION) > /dev/null 2>&1; \
	then \
		echo "INFO: cloudformation-package bucket found"; \
	else \
		echo "INFO: cloudformation-package bucket does not exist for $(REGION)"; \
		echo "INFO: creation cloudformation package bucket for $(REGION)"; \
		aws s3 mb s3://$(AWS_ACCOUNT)-cloudformation-packages-$(REGION) --region $(REGION); \
		aws s3api wait bucket-exists --bucket $(AWS_ACCOUNT)-cloudformation-packages-$(REGION) --region $(REGION); \
	fi