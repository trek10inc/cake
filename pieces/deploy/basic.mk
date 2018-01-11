# Simple deploy / update

AWS_ACCOUNT := $(shell aws sts get-caller-identity --output text --query 'Account')

deploy-basic: check-create-deployment-bucket
	@mkdir -p .packaged
	@aws cloudformation package --region $(region) \
			 --s3-bucket $(AWS_ACCOUNT)-cloudformation-packages-$(region) \
			 --s3-prefix $(STACK_NAME) \
			 --template-file .build/template.yml \
			 --output-template-file .packaged/template.yml; \
	if aws cloudformation describe-stacks --stack-name $(STACK_NAME) --region $(region) > /dev/null 2>&1; \
	then \
	  echo "INFO: stack found $(region).$(STACK_NAME)"; \
	  echo "INFO: stack updating $(region).$(STACK_NAME)"; \
		if aws cloudformation deploy --stack-name $(STACK_NAME) --template-file .packaged/template.yml --region $(region) --capabilities CAPABILITY_IAM; \
	  then \
			aws cloudformation wait stack-update-complete --stack-name $(STACK_NAME) --region $(region); \
			echo "INFO: update success $(region).$(STACK_NAME)"; \
	  else \
			echo "ERROR: failed to update $(region).$(STACK_NAME)"; \
	  fi \
	else \
	  echo "INFO: stack not found $(region).$(STACK_NAME)"; \
	  echo "INFO: stack creating $(region).$(STACK_NAME)"; \
		if aws cloudformation deploy --stack-name $(STACK_NAME) --template-file .packaged/template.yml --region $(region) --capabilities CAPABILITY_IAM; \
	  then \
			aws cloudformation wait stack-create-complete --stack-name $(STACK_NAME) --region $(region); \
			echo "INFO: create success $(region).$(STACK_NAME)"; \
	  else \
			echo "ERROR: failed to create $(region).$(STACK_NAME)"; \
	  fi \
	fi

check-create-deployment-bucket:
	@if aws s3 ls s3://$(AWS_ACCOUNT)-cloudformation-packages-$(region); \
	then \
		echo "INFO: cloudformation-package bucket found"; \
	else \
		echo "INFO: cloudformation-package bucket does not exist for $(region)"; \
		echo "INFO: creation cloudformation package bucket for $(region)"; \
		aws s3 mb s3://$(AWS_ACCOUNT)-cloudformation-packages-$(region) --region $(region); \
		aws s3api wait bucket-exists --bucket $(AWS_ACCOUNT)-cloudformation-packages-$(region) --region $(region); \
	fi
