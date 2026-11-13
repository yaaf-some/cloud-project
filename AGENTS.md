# AGENTS.md — rules for any AI agent working in this repo

You are working on **Runway** (see README.md). Yaaf owns it; you propose, he approves.

## Read first
1. The claude.ai Project doc `claude/runway-control-center.md` if you can reach it. Otherwise read `kb/how-this-works.md`.
2. The Linear issue you were given (workspace `yaaf-some`, team `YAA`, which may be renamed `RUN`).
3. The README of the lab you're touching.

## Hard rules
- **Fresh project.** Don't bring in earlier experiments (Floci, Online Boutique, SpinKube, "Harborline") unless they bring a clearly argued benefit.
- **No phases, no ADRs.** Labs are independent. Record decisions inline in the lab README as short "Why not X?" paragraphs (2–4 sentences).
- **Airgap is not a requirement.** Angular/Node are not required.
- **Real AWS beats emulation.** AWS Emulator, kind and k3d are for the inner loop only.
- **When Yaaf says something is "not used" or "irrelevant", delete it.** Don't keep it "just in case".
- **No AWS credentials in agent sessions.** Changes to real AWS go through GitHub Actions using the Lab 00 OIDC role, or through Yaaf's own terminal.
- **$0 idle.** Everything you create in AWS is tagged `project=runway`, `lab=<nn>`, `runway:ephemeral=true|false` and has a teardown path.
- **Supply chain:** pin GitHub Actions by commit SHA and container images by digest. Never add a dependency without saying why.

## Workflow
1. Branch from `main` using the Linear issue's branch name (`gitBranchName`). Never push to `main`.
2. Keep the change scoped to the issue. Anything else you notice becomes a new Linear issue with the `Idea` label.
3. Before finishing:
   - update the lab README (Proof, Cost receipt, Decisions, What broke) and its frontmatter `status`, and keep the root README lab table in sync
   - run `python3 tools/kb-check.py` and fix what it reports
   - hand off in a comment on the Linear issue: what changed, what's next, open questions, and the PR link. Then move the issue to the right state.
   - open a PR whose title includes the issue ID
4. Never mark a lab ✅ without a working proof.

## Cloud sessions
- The Cloud-Project environment runs `tools/cloud-setup.sh` (pinned, SHA256-checked tools). Bump a version and its hash together, then paste the file into the environment's setup script.
- Docker doesn't start on its own. Run `dockerd &` first.
- Open PRs with `gh api repos/yaaf-some/cloud-project/pulls`. `gh pr` uses GraphQL, which the proxy blocks.
- Never print or echo token variables.

## Knowledge-base rules (no wiki sprawl)
- Lab knowledge goes in the lab's README. `kb/` is only for what spans several labs, with at most 8 files and 250 lines each.
- Never create session, meeting or status notes in the repo. Those belong in Linear and the PR.
- Replace instead of appending. Delete anything stale; git history is the archive.
- Full rules: `kb/index.md`.

## Writing style
Short sentences. Show results before process. No marketing words. Numbers beat adjectives.
