DEFAULT_GOAL := help

lint: ## chart-testing lint (all charts)
	@docker run --rm --workdir=/data --volume $(shell pwd)/ct.yaml:/ct.yaml --volume $(shell pwd):/data quay.io/helmpack/chart-testing:v3.11.0 ct lint --all --config /ct.yaml

unittest: ## helm-unittest (all charts)
	@helm unittest charts/*

kubeconform: ## render + validate manifests
	@scripts/kubeconform-check.sh

docs: ## regenerate chart READMEs
	@docker run --rm -v $(shell pwd):/helm-docs jnorwood/helm-docs:v1.14.2 --chart-search-root=charts --template-files=../helm-docs/_templates.gotmpl --template-files=README.md.gotmpl

install-pre-commit: ## install pre-commit hooks (incl. commit-msg for commitizen)
	@pre-commit install
	@pre-commit install --hook-type commit-msg
	@pre-commit install-hooks

pre-commit: ## run all pre-commit hooks
	@pre-commit run --all-files

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'
