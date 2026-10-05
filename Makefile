SHELL := /bin/bash
AWS_REGION ?= ap-south-1
ENV ?= dev

.PHONY: bootstrap plan apply destroy lint test-alert port-forward docs

bootstrap:
	cd bootstrap && terraform init && terraform apply

plan:
	cd terraform/envs/$(ENV) && terraform init && terraform plan

apply:
	cd terraform/envs/$(ENV) && terraform init && terraform apply

destroy:
	cd terraform/envs/$(ENV) && terraform init && terraform destroy

lint:
	terraform -chdir=terraform/envs/dev fmt -check -recursive
	terraform -chdir=terraform/envs/prod fmt -check -recursive

test-alert:
	./scripts/test-alert.sh

port-forward:
	./scripts/port-forward.sh grafana

docs:
	@echo "Documentation is maintained under docs/ and README.md"
