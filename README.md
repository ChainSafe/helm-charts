# ChainSafe Helm Charts

Reusable Helm charts maintained by the ChainSafe DevOps team. Each chart lives
in its own folder, with its configuration parameters in `values.yaml`.

## Usage

```bash
helm repo add chainsafe https://chainsafe.github.io/helm-charts
helm repo update
helm install my-release chainsafe/<chart-name> --version <x.y.z> -f my-values.yaml
```

## Source code

The charts are developed in the [GitHub repository](https://github.com/ChainSafe/helm-charts).
