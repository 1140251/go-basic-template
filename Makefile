
export SHELL:=/bin/bash
export BASE_NAME:=$(shell basename ${PWD})

TEST_COVERAGE_THRESHOLD=80.0
BUILD_DIR:=./build
BINARY_NAME:=binary
DIAGRAMS_SRC := assets

default: help

help: ## Prints help for targets with comments
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-50s\033[0m %s\n", $$1, $$2}'
	@echo ""


vet: ## identifying subtle issues in code
	go vet ./...

.PHONY: test
test: ## Run test
	go test -v -cover -race ./... -coverprofile=coverage.out

check-coverage: ## Check coverage - Requires tests to run first
	coverage=$$(go tool cover -func=coverage.out | grep total | grep -Eo '[0-9]+\.[0-9]+') ;\
		rm coverage.out ;\
		if [ $$(bc <<< "$$coverage < $(TEST_COVERAGE_THRESHOLD)") -eq 1 ]; then \
			echo "Low test coverage: $$coverage < $(TEST_COVERAGE_THRESHOLD)" ;\
			exit 1 ;\
		fi

.PHONY: analyze
analyze: ## Analyze code using golangci-lint
	@docker run --rm \
    		-v ${PWD}:${PWD} \
    		-w ${PWD} \
    		golangci/golangci-lint:v1.47.2 \
    		golangci-lint run -v --config .golangci.yml

.PHONY: fmt
fmt: ## Format source using gofmt
	gofmt -l -s -w ./..

.PHONY: build
build: ## Compiles the package to build dir defined
	CGO_ENABLED=0 go build  -ldflags ${LDFLAGS} -a -o $(BUILD_DIR)/$(BINARY_NAME)


.PHONY: clean
clean: ## Lets you start from clean state
	rm -rf $(BINARY_DIR) $(PROJECT_DIR)


up: ## Run the package locally
	go run .


#########
# Docker #
#########

docker-build: ## Build docker image
	docker image build \
    		-t ${BASE_NAME}:latest .

docker-run: ## Run docker image
	@docker run --rm \
		${BASE_NAME}:latest


#########
# PLantUML #
#########

gen-plantuml: ## generate plantUML image
	@for each_uml in ${DIAGRAMS_SRC}/*.puml; do \
    			[ -f "$$each_uml" ] || continue; \
    			echo "converting $$each_uml"; \
    			cat $$each_uml | docker run --rm -i think/plantuml -tpng >  ${DIAGRAMS_SRC}/$$(basename "$$each_uml" .puml).png; \
    done; \



