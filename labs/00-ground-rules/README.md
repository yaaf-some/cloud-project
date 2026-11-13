---
lab: "00"
title: "Ground Rules"
status: now
effort: "1 weekend"
cost_estimate: "~$0"
cost_spent: 0
roles: [SA, Platform, Cloud, SRE, Security]
linear: "P-YAA-2"
---

# Lab 00 — Ground Rules

**Proof:** _not yet_

## Problem
Nobody knows what the AWS account costs, keys live in laptops, and nothing can be torn down with confidence. Before any lab touches AWS, the account needs a safety net: budgets, no static keys, remote state and a one-command teardown.

## What I built
_Planned:_
- AWS Budgets at $5 / $15 / $30 + Cost Anomaly Detection (YAA-9)
- Non-root IAM admin user with MFA, signed in with `aws login`; no long-lived keys (YAA-10)
- GitHub OIDC → AWS role scoped to `main` (YAA-11)
- Remote state bucket, required tags, Terraform vs OpenTofu pick (YAA-12)
- `make nuke` + nightly reaper workflow (YAA-13)
- README with proof and cost receipt (YAA-14)

## Cost receipt
| Spent | Idle | Teardown |
|---|---|---|
| — | — | — |

## Decisions
**Why not IAM Identity Center?** It grants access to AWS accounts only through an organization instance, and an account instance rejects permission sets. One account does not need an organization. An IAM user with MFA and `aws login` gives short-lived credentials without one.

## What broke
_Nothing yet._

## What I'd change
_TBD._

**Target roles:** SA, Platform, Cloud, SRE, Security
