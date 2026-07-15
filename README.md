# ChainSafe Helm Charts

Shared Helm charts, published to a GitHub Pages Helm repo.

## Usage

Add the repo and install a chart, pinning a version and supplying your values:

```bash
helm repo add chainsafe https://chainsafe.github.io/helm-charts
helm repo update
helm install my-release chainsafe/app-chart --version <x.y.z> -f my-values.yaml
```

`app-chart` renders **nothing** by default — describe each object in your
values file and set `enabled: true` on it. Full reference (a documented example
per kind) lives in [charts/app-chart](charts/app-chart):

```yaml
deployments:
  web:
    enabled: true
    spec:
      replicas: 2
      selector: { matchLabels: { app: web } }
      template:
        metadata: { labels: { app: web } }
        spec:
          containers:
            - name: web
              image: nginx:1.27
              resources:
                requests: { cpu: 50m, memory: 64Mi }
                limits: { cpu: 250m, memory: 128Mi }
```

## Charts

| Chart | Description |
|---|---|
| [app-chart](charts/app-chart) | Values-driven generic chart: one template per Kubernetes kind, specs spliced verbatim. Every object is OFF until `enabled: true`. |

Add a new chart later by dropping a folder under `charts/` with its own
`Chart.yaml`, `values.yaml`, `templates/`, and `tests/` — CI and publishing pick
it up automatically.

## Repository layout

```
helm-charts/
├── charts/                     # one folder per chart (each versioned independently)
│   └── app-chart/
│       ├── Chart.yaml          # name + version
│       ├── values.yaml         # documented; every object OFF by default
│       ├── templates/          # one template per Kubernetes kind
│       ├── tests/              # helm-unittest suites
│       ├── ci/                 # example values used by lint / kubeconform / Trivy
│       └── files/              # files injectable via dataFiles / templateFiles
├── scripts/                    # CI helpers (kubeconform check, unittest hook)
├── .github/
│   ├── workflows/              # helm-checks, trivy, chart-releaser
│   └── CODEOWNERS
├── ct.yaml                     # chart-testing config
├── lintconf.yaml               # yamllint rules for ct
├── .trivy.yaml                 # Trivy config
├── .pre-commit-config.yaml     # pre-commit hooks
├── cz.toml                     # commitizen (Conventional Commits)
├── Makefile                    # local dev targets
├── CONTRIBUTING.md             # how to contribute
├── docs/                       # tooling, publishing, chart-authoring guides
└── README.md
```

## Development

- `make lint` — chart-testing lint
- `make unittest` — helm-unittest
- `make kubeconform` — render + validate manifests
- `make docs` — regenerate chart READMEs
- `make pre-commit` — run all hooks

Charts are versioned with semver in each `Chart.yaml`; merging to `main` publishes any new versions automatically.

See **[docs/tooling.md](docs/tooling.md)** for the full toolchain (helm-unittest, `ct`, kubeconform, Trivy, commitizen), the test cases, and a flow diagram.

## Contributing

Changes go through a reviewed PR (protected `main`, `@ChainSafe/devops` via
CODEOWNERS). Every PR runs lint, unit tests, manifest validation, a security
scan, and a Conventional-Commit check — run `make pre-commit` locally first.
Workflow: [CONTRIBUTING.md](CONTRIBUTING.md).

## Docs

- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute (the workflow)
- [docs/tooling.md](docs/tooling.md) — toolchain, test cases, flow diagram, local setup
- [docs/chart-authoring.md](docs/chart-authoring.md) — how to add a new dedicated chart
- [docs/chart-publishing.md](docs/chart-publishing.md) — versioning and how charts get published

## Where this fits

This is **Stage A** of the wider GitOps overhaul: build and publish the charts first, prove they render exactly what runs today, *then* restructure ArgoCD (Stage B) to consume them. The charts must exist and be proven before the ArgoCD migration begins.

```
helm-charts repo (this)            infra-kubernetes repo (Stage B)
────────────────────               ──────────────────────────────
charts/app-chart  ──┐  published  clusters/<cluster>/apps/...
                      ├──(versioned)─► pins app-chart @ x.y.z
                      │                + supplies per-service values
                      └──────────────► existing ArgoCD syncs it
```
