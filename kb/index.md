---
title: Runway knowledge base
updated: 2026-11-13
---

# Runway knowledge base

Plain markdown. It reads the same on GitHub (web or the mobile app), in Obsidian, or in any editor. No paid sync and no plugins needed.

## What's here (this is the whole list)
- [how-this-works](how-this-works.md): the operating model. Board, sessions, scheduled tasks, cost guardrails.
- [radar](radar.md): one table of trends and tools being watched, max 25 rows.
- [research/2026-11-runway-report](research/2026-11-runway-report.md): the current foundation report.

The lab table is in the [root README](../README.md). Each lab's knowledge lives in its own `labs/NN-*/README.md`.

## Rules that keep this small
Most wikis fail by accumulating, Confluence-style. These rules are checked by `tools/kb-check.py`, which the weekly board-health task runs:

1. **Knowledge lives next to what it describes.** Anything about a lab goes in that lab's README. `kb/` holds only what spans several labs.
2. **Hard budget:** at most 8 files in `kb/` and 250 lines per file.
3. **Every `kb/` file is linked from this page.** Unlinked files get deleted.
4. **One radar table, at most 25 rows.** Adopted items move into a lab README. Dropped items are deleted.
5. **Replace, don't append.** A new research report replaces the old one. Git history is the archive.
6. **No session, meeting or status notes in the repo.** Handoffs go in the Linear issue comment and the PR description; they close with the issue.
7. **Delete freely.** Nothing is lost: `git log` keeps everything.
