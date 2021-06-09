checkov:
	checkov --directory=.

hclfmt:
	cd env/staging && terragrunt run-all hclfmt

.PHONY: \
	checkov \
	hclfmt