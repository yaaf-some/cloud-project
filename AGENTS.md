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
   - update the lab README (Proof, Cost receipt, Decisions, What broke) and its frontmatter `status`
   - add a session note `kb/sessions/YYYY-MM-DD-<issue>-<slug>.md` covering what changed, what's next and open questions
   - comment on the Linear issue with a summary and the PR link, and move it to the right state
   - open a PR whose title includes the issue ID
4. Never mark a lab ✅ without a working proof.

## Writing style
Short sentences. Show results before process. No marketing words. Numbers beat adjectives.
