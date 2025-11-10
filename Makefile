.SILENT:

# export PROJECT_NAME := 
export PROJECT_ROOT := $(shell pwd)
export SCRIPTS_DIR := $(PROJECT_ROOT)/scripts
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help

.PHONY: help
h help: ## Display this help message
	@echo "\033[33mUSAGE: make [TARGET]\033[0m"
	@echo ""
	@echo "\033[33mTARGET:\033[0m"
	@grep -hE '^[ a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: hooks
hooks: ## Attach git hooks
	$(SCRIPTS_DIR)/hooks.sh

.PHONY: deps
deps: ## Install project dependencies
	$(SCRIPTS_DIR)/dependencies.sh

.PHONY: audit
a audit: ## Audit dependencies for security vulnerabilities
	$(SCRIPTS_DIR)/audit.sh

.PHONY: docs
d docs:  ## Generate documentation
	$(SCRIPTS_DIR)/documentation-generate.sh

.PHONY: format
f format:  ## Check formatting
	$(SCRIPTS_DIR)/format-check.sh

.PHONY: lint
l lint:  ## Check lints
	$(SCRIPTS_DIR)/lint-check.sh

.PHONY: test
t test:  ## Run tests
	$(SCRIPTS_DIR)/test.sh

.PHONY: version
v version:  ## Check semantic versioning
	$(SCRIPTS_DIR)/version-check.sh

.PHONY: build
b build: ## Build project
	@echo "Use \`cargo\` to build project"

.PHONY: benchmark
benchmark: ## Run benchmarks
	$(SCRIPTS_DIR)/benchmark.sh

.PHONY: view-benchmark
view-benchmark: ## Open HTML wall-time benchmarks report
	$(SCRIPTS_DIR)/benchmark.sh
	open target/criterion/report/index.html
