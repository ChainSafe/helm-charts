# Contributing

How to contribute a change to this repo. For the tooling, test cases, and local
setup, see [docs/tooling.md](docs/tooling.md).

## How to contribute

1. **Raise an issue first** — describe the change (bug or feature) and get alignment before you start work.
2. **Branch off `main`** — e.g. `git switch -c feat/<chart>-<change>`.
3. **Make your change** under `charts/<chart>/` (or add a new chart folder — see [docs/chart-authoring.md](docs/chart-authoring.md)).
4. **Bump the chart `version`** in `charts/<chart>/Chart.yaml` (semver) — required to publish; a version is published once and never overwritten.
5. **Run the checks locally** until green: `make pre-commit` (plus `make unittest`, `make lint`, `make kubeconform`).
6. **Commit** with a Conventional Commit message (`feat:` / `fix:` / `chore:` …) — the type drives the version bump.
7. **Open a PR** (link the issue). CI runs every check and requests review from `@ChainSafe/devops` (CODEOWNERS). Fix anything red.
8. **Merge once approved + green.** `chart-releaser` publishes the new chart version automatically.

> Never push to `main` directly or hand-edit a cluster — everything goes through a reviewed PR.
