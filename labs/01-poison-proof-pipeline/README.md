---
lab: "01"
title: "Poison-Proof Pipeline"
status: next
effort: "2 weekends"
cost_estimate: "~$0"
cost_spent: 0
roles: [Platform, Security, Defense]
linear: "P-YAA-3"
---

# Lab 01 — Poison-Proof Pipeline

**Proof:** _not yet_

## Problem
2026 supply-chain attacks (Shai-Hulud waves, two LiteLLM compromises) went through CI and shipped with valid provenance. Signing alone isn't enough.

## What I built
- First SHA-pinned workflow: [`kb-check.yml`](../../.github/workflows/kb-check.yml) runs `tools/kb-check.py` on every PR to `main`. Read-only token, no secrets, no stored git credentials. `actionlint` and `zizmor` (pedantic) report zero findings.

_Planned:_
- SHA-pinned actions everywhere, digest-pinned images
- SBOM + cosign + provenance
- Dependency cooldown, install scripts blocked
- OIDC minting restricted to main
- Replay a `.pth` startup-hook payload and show it blocked or detected

## Cost receipt
| Spent | Idle | Teardown |
|---|---|---|
| — | — | — |

## Decisions
**Why not `actions/setup-python`?** kb-check uses only the standard library and runs on any Python 3.9+. The `ubuntu-24.04` runner ships Python 3.12, and the runner label is pinned, so the version only moves when the label does. One fewer third-party action is one fewer thing to pin and trust.

**Why pin by SHA, not `@v7`?** A tag can be moved to a malicious commit; a commit SHA can't. The `# v7.0.1` comment keeps it readable. SHAs were resolved with `git ls-remote --tags`, not guessed.

**Why `persist-credentials: false`?** By default checkout writes the job token into `.git/config`, where any later step can read it. kb-check never pushes, so the token isn't kept.

## What broke
_Nothing yet._

## What I'd change
_TBD._

**Target roles:** Platform, Security, Defense
