---
name: Bug report
about: Report a chart that renders or behaves incorrectly
title: "[bug] "
labels: bug
assignees: ""
---

## Summary

<!-- A clear, one-paragraph description of the bug. -->

## Affected chart

- Chart: <!-- e.g. app-chart -->
- Chart version: <!-- from Chart.yaml / the release you installed -->

## Values to reproduce

<!-- The minimal values file (or -f overrides) that triggers the issue. -->

```yaml
# values.yaml
```

## Steps to reproduce

1. `helm template my-release chainsafe/app-chart -f values.yaml`
2. <!-- ... -->

## Expected behavior

<!-- What you expected the rendered manifests / release to do. -->

## Actual behavior

<!-- What actually happened. Paste the relevant rendered output or error. -->

```
```

## Environment

- Helm version: <!-- helm version --short -->
- Kubernetes version: <!-- kubectl version --short, if relevant -->
