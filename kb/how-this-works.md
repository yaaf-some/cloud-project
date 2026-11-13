---
title: How this project runs
updated: 2026-11-13
---

# How this project runs

## Where things live
| What | Where |
|---|---|
| Code, lab write-ups, this knowledge base | this repo (Obsidian vault = repo root) |
| Work items and the board | Linear workspace `yaaf-some`, team `YAA` (may be renamed `RUN`), one Linear project per lab plus "Control Center" |
| Briefing for Claude sessions | claude.ai Project "Cloud-project" → `claude/runway-control-center.md` |
| Session history | [[sessions]] folder: one note per session |

## The board (Linear)
| Column | Linear state |
|---|---|
| **Now** (max 2) | In Progress |
| **Next** | Todo |
| **Later** | Backlog |
| **Ideas** | Backlog + `Idea` label |

- The `Role` label group (SA, Platform, Cloud, SRE, Security, AI Infra, Defense) shows what an issue showcases.
- The `Control Center` label marks meta work: repo, knowledge base, sessions, automation.
- New trends never trigger a plan rewrite. They become `Idea` issues and, if useful, a radar note.

## Sessions
- **Control center:** one long-running Claude session that plans, dispatches and reviews. It keeps no state in its head; everything lives in the repo, Linear and the Project doc, so any new session can take over.
- **Cloud workers:** background Claude agents. Each takes one Linear issue, works on its branch, and opens a PR. **They never get AWS credentials.**
- **Local sessions:** Claude Code on Yaaf's Mac, for anything that needs his AWS login. Start one with "work on YAA-NN".
- **Scheduled tasks:**
  - weekly **trend radar** (adds radar notes and `Idea` issues)
  - weekly **board health** (stale work, too much in Now, labs missing cost receipts)
  - one-off **re:Invent 2026 digest** (Dec 5)

## Real AWS without surprise bills
- Budgets alert at $5 / $15 / $30, and Cost Anomaly Detection is on.
- Every resource is tagged `project=runway`, `lab=<nn>`, `runway:ephemeral`.
- `make up` / `make down` per lab, `make nuke` for everything, and a nightly reaper deletes ephemeral resources older than 6 hours.
- Changes reach AWS only through GitHub Actions (OIDC, scoped to `main`) or Yaaf's own terminal.

## Writing a lab
Copy `templates/lab-README.md`. Lead with the proof. Every lab has a cost receipt. Record decisions inline as "Why not X?" paragraphs. There are no ADRs and no phases.
