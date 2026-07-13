# Adding a new chart

## First: do you need a new chart?

- **If the service fits the generic shape** (deployment/statefulset, service,
  ingress, config, secrets — anything expressible as Kubernetes objects), use
  **`generic-app`** with a values file. Don't add a chart.
- **Only add a dedicated chart** when a service has real chart *logic* the
  generic chart can't express — a CRD, an operator, complex conditional wiring.
  A new chart that just re-implements `generic-app` is a maintenance trap.

## Skeleton

Create one folder under `charts/`, same shape as `generic-app`:

```
charts/<name>/
├── Chart.yaml            # apiVersion: v2, name: <name>, version: 0.1.0
├── values.yaml           # documented (# -- comments feed the README)
├── README.md.gotmpl      # helm-docs template (README.md is generated)
├── .helmignore           # exclude tests/, ci/, *.gotmpl from the package
├── templates/            # your templates
├── tests/                # helm-unittest suites (required)
└── ci/
    └── example-values.yaml   # realistic values for lint / kubeconform / Trivy
```

## Steps

1. **`Chart.yaml`** — `apiVersion: v2`, a unique `name`, `version: 0.1.0`,
   `type: application`, and a `maintainers` entry.
2. **`values.yaml`** — start empty/off-by-default; document each key with a
   `# --` comment (helm-docs turns these into the README table) and add a short
   commented example after each.
3. **`templates/`** — write the templates. Keep secrets out of the chart; use
   ExternalSecrets or values.
4. **`tests/`** — add helm-unittest suites asserting the rendered output. This
   is required: it's what locks behavior. Run `make unittest`.
5. **`ci/example-values.yaml`** — a realistic values file. `ct lint`,
   `kubeconform`, and Trivy all render the chart with it, so make it clean
   (resources set, hardened `securityContext`, no HIGH/CRITICAL Trivy findings).
6. **`README.md.gotmpl` + `.helmignore`** — copy `generic-app`'s, then run
   `make docs` to generate `README.md`. Never hand-edit the generated README.
7. **(Optional) CODEOWNERS** — add a `/charts/<name>/ @team` line if a specific
   team owns it.

## What you get for free

CI discovers the new chart automatically — no workflow edits:

- `ct lint` (via `ct list-changed`) lints it on PRs that touch it.
- `helm-unittest` runs its `tests/`.
- `kubeconform` validates its `ci/` render.
- Trivy scans its `ci/` render for misconfig + secrets.
- On merge to `main`, `chart-releaser` publishes it once `version` is set.

## Verify locally before opening a PR

```bash
make unittest
make lint
make kubeconform
make pre-commit
```

See [chart-publishing.md](chart-publishing.md) for how the chart then gets versioned and
published.
