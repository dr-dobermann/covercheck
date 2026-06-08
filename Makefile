GO = go

# Diff-coverage gate applied to this repo itself (dogfooding).
COVER_MIN ?= 80
COVER_BASE ?= origin/master

build:
	$(GO) build ./...
.PHONY: build

test:
	$(GO) test -race ./...
.PHONY: test

lint:
	golangci-lint run --timeout=5m
.PHONY: lint

vuln:
	govulncheck ./...
.PHONY: vuln

# Run covercheck on its own changed lines (cmd/ is excluded by default).
cover-check:
	$(GO) test -race -coverprofile=coverage.txt ./...
	$(GO) run ./cmd/covercheck -min $(COVER_MIN) -base $(COVER_BASE) -profiles coverage.txt
.PHONY: cover-check

# Full local-equivalent of CI.
ci: lint build test cover-check vuln
.PHONY: ci
