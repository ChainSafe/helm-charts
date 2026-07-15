# Maintainers

This repository is owned and maintained by the ChainSafe DevOps team.

| Maintainer | Contact |
|---|---|
| [@ChainSafe/devops](https://github.com/orgs/ChainSafe/teams/devops) | GitHub team |

## Responsibilities

The maintainers are responsible for:

- Reviewing and merging pull requests.
- Triaging issues and answering questions.
- Cutting releases (publishing new chart versions).
- Keeping CI, tooling, and this repository's standards up to date.

`@ChainSafe/devops` is the sole code owner (see [.github/CODEOWNERS](.github/CODEOWNERS))
and is auto-requested for review on every pull request.

## Decision process

- Every change lands through a reviewed pull request — direct pushes to `main`
  are not allowed.
- A change requires at least **one** approving review from `@ChainSafe/devops`
  and all required status checks passing.
- Disagreements are resolved by consensus within the DevOps team; the team lead
  has the final say when consensus can't be reached.

## Releases

Publishing is automated: merging to `main` triggers `chart-releaser`, which
packages and publishes any chart whose `version` is new. See
[docs/chart-publishing.md](docs/chart-publishing.md).
