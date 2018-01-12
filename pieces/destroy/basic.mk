destroy-basic:
	@echo "INFO: destroying $(region).$(STACK_NAME)"
	@aws cloudformation delete-stack --stack-name $(STACK_NAME) --region $(region)
	@echo "INFO: waiting for $(region).$(STACK_NAME) to be destroyed"
	@aws cloudformation wait stack-delete-complete --stack-name $(STACK_NAME) --region $(region)
