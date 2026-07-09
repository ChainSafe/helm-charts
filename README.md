# ChainSafe Helm Charts

Shared Helm charts, published to a GitHub Pages Helm repo.

## Usage

```bash
helm repo add chainsafe https://chainsafe.github.io/helm-charts
helm repo update
helm install my-release chainsafe/generic-app --version <x.y.z>
```

## Charts

| Chart | Description |
|---|---|
| [generic-app](charts/generic-app) | Values-driven generic chart: one template per Kubernetes kind, specs spliced verbatim. Every object is OFF until `enabled: true`. |

## Development

- `make lint` — chart-testing lint
- `make unittest` — helm-unittest
- `make kubeconform` — render + validate manifests
- `make docs` — regenerate chart READMEs
- `make pre-commit` — run all hooks

Charts are versioned with semver in each `Chart.yaml`; merging to `main` publishes any new versions automatically.

## Related docs (Notion)

- [A Shared Helm Charts Repo (Generic + Canton)](https://app.notion.com/p/chainsafe/A-Shared-Helm-Charts-Repo-Generic-Canton-38f2103664e88087a0f5ca01ad646b1b)
- [Generic Chart Migration — Proposal Doc](https://app.notion.com/p/chainsafe/Generic-Chart-Migration-Proposal-Doc-37c2103664e88074ba81f692c5aa323d)
- [ArgoCD Setup — Simple and Generic](https://app.notion.com/p/chainsafe/ArgoCD-Setup-Simple-and-Generic-38f2103664e880dba886fba7c9f507c0)

## Where this fits

This is **Stage A** of the wider GitOps overhaul: build and publish the charts first, prove they render exactly what runs today, *then* restructure ArgoCD (Stage B) to consume them. The charts must exist and be proven before the ArgoCD migration begins.

```
helm-charts repo (this)            infra-kubernetes repo (Stage B)
────────────────────               ──────────────────────────────
charts/generic-app  ──┐  published  clusters/<cluster>/apps/...
                      ├──(versioned)─► pins generic-app @ x.y.z
                      │                + supplies per-service values
                      └──────────────► existing ArgoCD syncs it
```
