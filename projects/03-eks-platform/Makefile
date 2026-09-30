.PHONY: init fmt validate plan apply destroy kubeconfig deploy

init:
	terraform init

fmt:
	terraform fmt -recursive

validate:
	terraform fmt -check
	terraform validate

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

kubeconfig:
	terraform output -raw kubectl_command

# Run after the cluster is created.
deploy:
	kubectl apply -f kubernetes/application.yaml
