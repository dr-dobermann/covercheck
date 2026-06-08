GO = go

# Diff-coverage gate applied to this repo itself (dogfooding).
COVER_MIN ?= 80
COVER_BASE ?= origin/master

build:
	$(GO) build ./...
.PHONY: build

test:
	$(GO) test -race -coverprofile=coverage.txt ./...
.PHONY: test

lint:
	golangci-lint run --timeout=5m
.PHONY: lint

vuln:
	govulncheck ./...
.PHONY: vuln

# Run covercheck on its own changed lines (cmd/ is excluded by default).
# Consumes the coverage.txt that `test` writes — run `make test` first, or use
# `make ci` which orders them.
cover-check:
	$(GO) run ./cmd/covercheck -min $(COVER_MIN) -base $(COVER_BASE) -profiles coverage.txt
.PHONY: cover-check

# Full local-equivalent of CI (test writes coverage.txt; cover-check consumes).
ci: lint build test cover-check vuln
.PHONY: ci
