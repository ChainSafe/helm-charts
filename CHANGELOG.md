# Changelog

All notable changes to this repository are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this repository adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Individual charts are versioned independently in their own `Chart.yaml`; this
file tracks repository-wide changes (charts, CI, tooling, structure). Per-chart
release notes are generated automatically by `chart-releaser` on each release.

## [Unreleased]

### Added

- `app-chart` chart: values-driven, one template per Kubernetes kind, specs
  spliced verbatim; every object is off until `enabled: true`.
- CI: chart-testing lint, helm-unittest, kubeconform manifest validation,
  Trivy security scan, and a Conventional-Commit check.
- Automated publishing to a GitHub Pages Helm repo via `chart-releaser`.
- Contributor docs: `CONTRIBUTING.md`, `docs/tooling.md`,
  `docs/chart-authoring.md`, `docs/chart-publishing.md`.
- `MAINTAINERS.md`.

[Unreleased]: https://github.com/ChainSafe/helm-charts/commits/main
