destroy-basic:
	@echo "INFO: destroying $(REGION).$(STACK_NAME)"
	@aws cloudformation delete-stack --stack-name $(STACK_NAME) --region $(REGION)
	@echo "INFO: waiting for $(REGION).$(STACK_NAME) to be destroyed"
	@aws cloudformation wait stack-delete-complete --stack-name $(STACK_NAME) --region $(REGION)
