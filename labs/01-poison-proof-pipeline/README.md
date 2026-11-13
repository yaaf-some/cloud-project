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
_Planned:_
- SHA-pinned actions, digest-pinned images
- SBOM + cosign + provenance
- Dependency cooldown, install scripts blocked
- OIDC minting restricted to main
- Replay a `.pth` startup-hook payload and show it blocked or detected

## Cost receipt
| Spent | Idle | Teardown |
|---|---|---|
| — | — | — |

## Decisions
_None yet._

## What broke
_Nothing yet._

## What I'd change
_TBD._

**Target roles:** Platform, Security, Defense
