# Simple deploy / update

AWS_ACCOUNT := $(shell aws sts get-caller-identity --output text --query 'Account')

deploy-basic: check-create-deployment-bucket
	@mkdir -p .packaged
	@aws cloudformation package --region $(region) \
			 --s3-bucket $(AWS_ACCOUNT)-cloudformation-packages-$(region) \
			 --s3-prefix $(STACK_NAME) \
			 --template-file .build/template.yml \
			 --output-template-file .packaged/template.yml > /dev/null; \
	if aws cloudformation describe-stacks --stack-name $(STACK_NAME) --region $(region) > /dev/null 2>&1; \
	then \
	  echo "INFO: stack found $(region).$(STACK_NAME)"; \
	  echo "INFO: stack updating $(region).$(STACK_NAME)"; \
		aws cloudformation deploy --stack-name $(STACK_NAME) --template-file .packaged/template.yml --region $(region) --capabilities CAPABILITY_IAM |\
		while read line; do \
			echo "INFO: $$line"; \
		done \
	else \
	  echo "INFO: stack not found $(region).$(STACK_NAME)"; \
	  echo "INFO: stack creating $(region).$(STACK_NAME)"; \
		aws cloudformation deploy --stack-name $(STACK_NAME) --template-file .packaged/template.yml --region $(region) --capabilities CAPABILITY_IAM |\
		while read line; do \
			echo "INFO: $$line"; \
		done \
	fi

check-create-deployment-bucket:
	@if aws s3 ls s3://$(AWS_ACCOUNT)-cloudformation-packages-$(region) > /dev/null 2>&1; \
	then \
		echo "INFO: cloudformation-package bucket found"; \
	else \
		echo "INFO: cloudformation-package bucket does not exist for $(region)"; \
		echo "INFO: creation cloudformation package bucket for $(region)"; \
		aws s3 mb s3://$(AWS_ACCOUNT)-cloudformation-packages-$(region) --region $(region); \
		aws s3api wait bucket-exists --bucket $(AWS_ACCOUNT)-cloudformation-packages-$(region) --region $(region); \
	fi