#!/usr/bin/env bash
# Renders every chart with its ci/*-values.yaml and validates the output with kubeconform.
set -euo pipefail
cd "$(dirname "$0")/.."

SCHEMA_LOC="https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"

fail=0
for chart in charts/*/; do
  [ -f "${chart}Chart.yaml" ] || continue
  for vf in "${chart}"ci/*-values.yaml; do
    [ -e "$vf" ] || continue
    echo "== kubeconform: $chart ($vf) =="
    if ! helm template release "$chart" -f "$vf" \
        | kubeconform -strict -ignore-missing-schemas \
            -schema-location default -schema-location "$SCHEMA_LOC" -summary; then
      fail=1
    fi
  done
done
exit $fail
