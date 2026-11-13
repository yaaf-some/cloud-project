---
title: How this project runs
updated: 2026-11-13
---

# How this project runs

## Where things live
| What | Where | Lifetime |
|---|---|---|
| Lab knowledge (decisions, proof, cost, what broke) | `labs/NN-*/README.md` | as long as the lab exists |
| Cross-lab knowledge | `kb/`, at most 8 files (see [index](index.md)) | replaced, never appended |
| Work items, the board, handoffs between sessions | Linear: workspace `yaaf-some`, team `YAA` (may be renamed `RUN`) | closes with the issue |
| Discussion of a change | the PR description and review | closes with the PR |
| Briefing for Claude sessions | claude.ai Project "Cloud-project" → `claude/runway-control-center.md` | kept current |

## Reading it on any device
- **Phone or tablet:** the GitHub mobile app or github.com. Markdown and Mermaid diagrams render there, and it's free.
- **Mac:** open the repo folder as an Obsidian vault for links and graph view, or use any editor. Git does the syncing: `git pull`.
- **iPhone with Obsidian (optional):** a free git client such as ObSync pulls the repo into an Obsidian vault. Not required.
- **Public site (optional, later):** the same markdown can be published free with Quartz on GitHub Pages. Tracked as a Linear `Idea`.

## The board (Linear)
| Column | Linear state |
|---|---|
| **Now** (max 2) | In Progress |
| **Next** | Todo |
| **Later** | Backlog |
| **Ideas** | Backlog + `Idea` label |

- The `Role` label group (SA, Platform, Cloud, SRE, Security, AI Infra, Defense) shows what each issue showcases.
- The `Control Center` label marks meta work.
- New trends never trigger a plan rewrite. They become `Idea` issues and, if worth watching, a row in [radar](radar.md).

## Sessions
- **Control center:** a long-running Claude session that plans, dispatches and reviews. It keeps no state in its head.
- **Cloud workers:** background Claude agents. One Linear issue each, its branch, a PR. **They never get AWS credentials.**
- **Local sessions:** Claude Code on Yaaf's Mac for anything that needs his AWS login. Start one with "work on YAA-NN".
- **Handoff:** every session ends with a comment on its Linear issue (what changed, what's next, open questions) and the PR link.
- **Scheduled tasks:**
  - weekly **trend radar**: updates [radar](radar.md) and adds `Idea` issues
  - weekly **board health**: Linear hygiene and `tools/kb-check.py`
  - one-off **re:Invent 2026 digest**: Dec 5

## Real AWS without surprise bills
- Budgets at $5 / $15 / $30, and Cost Anomaly Detection.
- Tags on everything: `project=runway`, `lab=<nn>`, `runway:ephemeral`.
- `make up` / `make down` per lab, `make nuke` for everything, and a nightly reaper that deletes ephemeral resources older than 6 hours.
- Changes reach AWS only through GitHub Actions (OIDC, scoped to `main`) or Yaaf's own terminal.

## Writing a lab
Copy `templates/lab-README.md`. Lead with the proof. Every lab has a cost receipt. Decisions go inline as "Why not X?" paragraphs.
