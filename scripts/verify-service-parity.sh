#!/usr/bin/env bash
# verify-service-parity.sh — proves generic-app renders identical objects to the
# legacy definitions/canton chart for a single service, using a hand-authored
# values file and (optionally) canton config files copied into the chart's files/.
#
# usage: scripts/verify-service-parity.sh <infra-kubernetes-path> <legacy-valuefile> <new-valuefile> <name-filter> [config-file ...]
set -euo pipefail
cd "$(dirname "$0")/.."

INFRA="${1:?path to infra-kubernetes checkout}"
LEGACY_VF="${2:?legacy values file (relative to infra-kubernetes)}"
NEW_VF="${3:?new generic-app values file}"
FILTER="${4:?object name filter}"
shift 4

WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"; rm -f charts/generic-app/files/__parity_*' EXIT
mkdir -p "$WORK/old" "$WORK/new"

# Copy any canton config files into the chart's files/ as parity test inputs.
for cf in "$@"; do
  cp "$cf" "charts/generic-app/files/$(basename "$cf")"
done

helm template cmp "$INFRA/definitions/canton" -f "$INFRA/$LEGACY_VF" > "$WORK/old.yaml"
helm template cmp charts/generic-app -f "$NEW_VF" > "$WORK/new.yaml"

split() { yq 'select(.!=null) | sort_keys(..)' "$WORK/$1.yaml" | (cd "$WORK/$1" && yq -s '.kind + "_" + .metadata.name' -); }
split old; split new
find "$WORK/old" "$WORK/new" -type f ! -name "*${FILTER}*" -delete

if diff -ru "$WORK/old" "$WORK/new"; then
  echo "OK: $FILTER renders identically in generic-app and the legacy chart"
fi
