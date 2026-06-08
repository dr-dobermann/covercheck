# covercheck — Go diff-coverage gate

A tiny, dependency-free Go tool that fails when the source lines a change *adds
or modifies* are covered below a threshold — **patch (diff) coverage**. It judges
only changed lines, so a repository's pre-existing untouched-code coverage
backlog never blocks a PR.

It reads the coverage profiles `go test -coverprofile` already produces and the
`git diff` against a base ref; it needs no external service (works the same
locally and in CI) and pulls in nothing beyond the Go standard library (the test
suite uses testify).

## Install

```bash
go install github.com/dr-dobermann/covercheck/cmd/covercheck@latest
```

## Use

```bash
# produce a coverage profile
go test -coverprofile=coverage.txt ./...

# fail if the changed lines (vs origin/master) are < 80% covered
covercheck -min 80 -base origin/master -profiles coverage.txt
```

Flags:

| Flag | Default | Meaning |
|---|---|---|
| `-min` | `70` | minimum patch-coverage percent; exit 1 below it |
| `-base` | `origin/master` | ref to diff against (uses `base...HEAD`, i.e. the merge-base) |
| `-profiles` | `coverage.txt` | comma-separated Go coverage profiles |

It diffs the **committed** state (`base...HEAD`) so a local run and CI agree.
In CI, check out with full history (`fetch-depth: 0`) so the merge-base resolves.

Excluded from measurement by default (entry points / non-product code):
`*_test.go`, `cmd/**`, `generated/**` (mocks), `examples/**`.

## Exit codes

`0` pass · `1` below the threshold · `2` error (no profile, bad base ref, …).

## License

LGPL-3.0 — see [LICENSE](LICENSE).
