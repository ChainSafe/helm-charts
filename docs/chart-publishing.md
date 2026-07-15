# Publishing & versioning

How a chart change becomes an installable, versioned package.

## Versioning (semver)

Each chart carries a `version` in its `Chart.yaml` (`major.minor.patch`). It's
what consumers — and ArgoCD — pin to, so bumps must be deliberate.

| Change | Bump | Conventional Commit |
|---|---|---|
| Backwards-compatible fix | patch (`0.1.0 → 0.1.1`) | `fix:` |
| New capability, compatible | minor (`0.1.0 → 0.2.0`) | `feat:` |
| Breaking change | major (`0.1.0 → 1.0.0`) | `feat!:` / `BREAKING CHANGE:` |

Rules:

- **Bump the chart `version` in the same PR that changes the chart.** If you
  don't, publishing is a no-op (see below) and consumers never get the change.
- **A version is published once and never overwritten** — immutable. To ship a
  change you must bump the version.
- **`version` vs `appVersion`:** bump `version` for chart changes; bump
  `appVersion` when the underlying application image changes.
- **Charts are versioned independently** — editing one chart doesn't re-release
  another.

## How publishing works

On merge to `main`, the `chart-releaser` workflow (`.github/workflows/chart-releaser.yaml`):

1. Packages every chart whose `version` isn't already released (existing
   versions are skipped — that's the immutability guarantee).
2. Publishes the packages to the GitHub Pages Helm repo and updates `index.yaml`
   on the `gh-pages` branch.
3. Creates a Git tag + release notes per published chart.

Nothing is packaged or pushed by hand — **merging to `main` is the release.**

## Consuming a published chart

```bash
helm repo add chainsafe https://chainsafe.github.io/helm-charts
helm repo update
helm install my-release chainsafe/app-chart --version <x.y.z> -f my-values.yaml
```

ArgoCD (Stage B) consumes the same published chart by pinning a version and
supplying per-service values.

## Prerequisites (one-time)

Publishing to GitHub Pages requires:

- **The repo is public.** GitHub Pages publishing doesn't work from a private
  repo (or would expose a public site with private, auth-gated packages). While
  the repo is private, PR CI still runs — only publishing waits.
- **A `gh-pages` branch must already exist.** `chart-releaser-action` does *not*
  create it — `cr index` checks out `origin/gh-pages` to commit `index.yaml`, so
  the first `main` push fails (half-published: release exists, index doesn't) if
  the branch is missing. Create it once, up front:

  ```bash
  git switch --orphan gh-pages
  git commit --allow-empty -m "chore: init gh-pages"
  git push origin gh-pages
  git switch main
  ```

- **Pages enabled** — Settings → Pages → deploy from the `gh-pages` branch.

The release job declares `permissions: contents: write` itself, so the
repo-level **Workflow permissions** setting can stay at the default **Read**
— only this job gets write access.

## Cutting a release — checklist

1. Make the chart change on a branch.
2. Bump `version` in the chart's `Chart.yaml`.
3. Open a PR; get it green + approved; merge to `main`.
4. `chart-releaser` runs and publishes the new version automatically.
