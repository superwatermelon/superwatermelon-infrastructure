SHELL = /bin/sh

TFPLAN_PATH = terraform.tfplan

TERRAFORM = terraform

TERRAFORM_DIR = terraform

.PHONY: default
default: load plan

.PHONY: check
check:
ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION is undefined)
endif

ifndef TFSTATE_BUCKET
	$(error TFSTATE_BUCKET is undefined)
endif

ifndef INTERNAL_AWS_PROFILE
	$(error INTERNAL_AWS_PROFILE is undefined)
endif

ifndef TEST_AWS_PROFILE
	$(error TEST_AWS_PROFILE is undefined)
endif

ifndef STAGE_AWS_PROFILE
	$(error STAGE_AWS_PROFILE is undefined)
endif

ifndef LIVE_AWS_PROFILE
	$(error LIVE_AWS_PROFILE is undefined)
endif

ifndef INTERNAL_TFSTATE_BUCKET
	$(error INTERNAL_TFSTATE_BUCKET is undefined)
endif

ifndef TEST_TFSTATE_BUCKET
	$(error TEST_TFSTATE_BUCKET is undefined)
endif

ifndef STAGE_TFSTATE_BUCKET
	$(error STAGE_TFSTATE_BUCKET is undefined)
endif

ifndef LIVE_TFSTATE_BUCKET
	$(error LIVE_TFSTATE_BUCKET is undefined)
endif

.PHONY: load
load: check
	$(TERRAFORM) init \
		-no-color \
		-backend=true \
		-input=false \
		-backend-config bucket=$(TFSTATE_BUCKET) \
		-backend-config region=$(AWS_DEFAULT_REGION) \
		$(TERRAFORM_DIR)

.PHONY: plan
plan: check
	$(TERRAFORM) plan \
		-no-color \
		-var internal_aws_profile=$(INTERNAL_AWS_PROFILE) \
		-var test_aws_profile=$(TEST_AWS_PROFILE) \
		-var stage_aws_profile=$(STAGE_AWS_PROFILE) \
		-var live_aws_profile=$(LIVE_AWS_PROFILE) \
		-var internal_tfstate_bucket=$(INTERNAL_TFSTATE_BUCKET) \
		-var test_tfstate_bucket=$(TEST_TFSTATE_BUCKET) \
		-var stage_tfstate_bucket=$(STAGE_TFSTATE_BUCKET) \
		-var live_tfstate_bucket=$(LIVE_TFSTATE_BUCKET) \
		-out $(TFPLAN_PATH) \
		$(TERRAFORM_DIR)

.PHONY: apply
apply:
	$(TERRAFORM) apply \
		-no-color \
		$(TFPLAN_PATH)

.PHONY: destroy
destroy: check
	$(TERRAFORM) destroy \
		-no-color \
		-var internal_aws_profile=$(INTERNAL_AWS_PROFILE) \
		-var test_aws_profile=$(TEST_AWS_PROFILE) \
		-var stage_aws_profile=$(STAGE_AWS_PROFILE) \
		-var live_aws_profile=$(LIVE_AWS_PROFILE) \
		-var internal_tfstate_bucket=$(INTERNAL_TFSTATE_BUCKET) \
		-var test_tfstate_bucket=$(TEST_TFSTATE_BUCKET) \
		-var stage_tfstate_bucket=$(STAGE_TFSTATE_BUCKET) \
		-var live_tfstate_bucket=$(LIVE_TFSTATE_BUCKET) \
		$(TERRAFORM_DIR)
