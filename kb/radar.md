---
title: Trend radar
updated: 2026-11-13
max_rows: 25
---

# Trend radar

One table, at most 25 rows. **Adopted** rows move into the lab README that uses them and leave this table. **Dropped** rows are deleted; git history keeps them. A row stays only while it's still being watched.

✔ = confirmed in a primary source (vendor docs, release notes, CNCF). ? = not yet confirmed.

| Item | What it is | Why it matters / labs | ✔ | Updated | Source |
|---|---|---|---|---|---|
| OpenShell | NVIDIA-led CNCF Sandbox project: kernel-level policy on agent file, syscall and network access; credential placeholders; deny-by-default egress. v0.1.x | Core of Lab 05 locally. Pin the version (policies are moving to Cedar). | ✔ | 2026-11-13 | [CNCF](https://www.cncf.io/projects/openshell/) |
| Nitro Sandboxes | AWS hardware-isolated microVM per pod or task (EKS, ECS Managed Instances, EC2), launched Nov 9, 2026, no extra charge. `runtimeClassName: isolated-sandbox`. No GPU pods | Cloud half of Lab 05; also Lab 06 | ✔ | 2026-11-13 | [coverage](https://runtimewire.com/article/aws-nitro-sandboxes-eks-ecs-ec2-hardware-isolated-vms) |
| Agent Substrate | Google-donated CNCF Sandbox runtime: gVisor/microVM-only agent sandboxing with suspend/resume. kagent's default backend. Pre-1.0 outside GKE | Alternative in Lab 05, worth a "Why not X?" paragraph | ✔ | 2026-11-13 | [GitHub](https://github.com/agent-substrate/substrate) |
| AWS Emulator | Free, CC0 local emulator for 200+ services (GA Nov 11, 2026), with a published list of known discrepancies | Inner loop and CI only (Labs 00, 02). Proofs stay on real AWS | ✔ | 2026-11-13 | [SiliconANGLE](https://siliconangle.com/2026/11/11/amazons-open-source-aws-emulator-lets-developers-validate-their-code-locally-without-the-cloud/) |
| Lambda Managed Instances | Lambda on chosen EC2: $0.20/M requests + 15% on top of EC2. One AWS benchmark puts break-even at about 9 rps steady state | The middle option in Lab 02. SOCI support unconfirmed (YAA-15) | ✔ | 2026-11-13 | [AWS docs](https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances.html) |
| LiteLLM compromises | Backdoored twice in 2026: March via Trivy in its CI; Oct 1.107.0 via a `.pth` startup-hook stealer in both PyPI and Docker images | Motivates Lab 01's payload replay and Lab 07's gateway choice | ✔ | 2026-11-13 | [LiteLLM](https://docs.litellm.ai/blog/security-update-march-2026) |
