---
title: "Runway: A Portfolio and Lab Project Plan for a Platform and Cloud Engineer Entering the 2027 LA Market"
date: 2026-11-13
type: deep-research
status: foundation
---

# Runway: a portfolio and lab plan for a platform/cloud engineer entering the 2027 LA market

> Deep research report, Nov 13, 2026. Runway is built on it. Claims marked *unverified* in the Caveats section need checking before you cite them (Linear YAA-15). Sources are listed at the end.

Build one coherent, cheap, real-AWS project. Call it **"Runway"**: a small internal platform that lets a 30-engineer company ship services *and* AI agents safely. Deliver it as an any-order menu of labs, each taking one to three weekends. Each lab produces a working artifact, a cost receipt and a short "what I'd change" write-up.

The late-2026 evidence supports this direction:
- CNCF's KubeCon NA 2026 headline was agent isolation and governance (OpenShell, Agent Substrate, gVisor).
- AWS shipped hardware-isolated pods for agents (Nitro Sandboxes) on November 9, 2026.
- Supply-chain attacks on CI pipelines and AI tooling (Shai-Hulud waves, two LiteLLM compromises) dominated 2026 security news.
- Platform hiring managers say they want evidence you built something other engineers would actually use.

Runway lets you tell your strongest story: "I take chaotic, manual, risky environments and make them boring, self-service and cheap."

## TL;DR

- **Build "Runway," a paved-road platform for services and AI agents, on real AWS with $0 idle cost.** It combines:
  - GitOps on ephemeral EKS Auto Mode with Gateway API
  - a supply-chain-hardened pipeline
  - short-lived workload identity
  - sandboxed agents (OpenShell locally, Nitro Sandboxes on EKS)
  - token-level AI cost metering
  - SLO-based observability

  That covers the 2026 trend stack: agents, supply-chain security, FinOps for AI, serverless-vs-container economics, and hybrid/repatriation. No airgap, no Angular/Node.
- **Organize it as a lab menu, not phases.** About 11 self-contained labs, done in any order. Each has one README from a shared template (Problem → What I built → Proof → Cost receipt → Decisions inline → What broke → What I'd change), tracked on a Now/Next/Later/Ideas board. Start with Lab 0, "Ground Rules": budgets, GitHub OIDC (no static keys), remote state and a one-command teardown. It costs about $0 and gives you your first resume bullet.
- **For the job hunt:**
  - Lead with AWS Solutions Architect Associate plus CKA.
  - Show AI fluency through *governed* agents rather than chatbots.
  - Treat defense tech as an optional branch. Anduril-type roles genuinely use Kubernetes, GitOps and signing, but they nearly always require US-person status and clearance eligibility. Under the adjudicative guidelines, foreign military service such as IDF reserve duty is a recognized foreign-preference concern that carries a "heavy burden" to mitigate. Get a clearance attorney's opinion before investing in that path.

## Key findings

### 1. Where the industry moved, late 2025 to November 2026

**AI agents became an infrastructure problem: sandboxing, identity and policy.** At KubeCon + CloudNativeCon NA 2026 (Salt Lake City, Nov 9–12), CNCF highlighted new Sandbox projects including OpenShell and Agent Substrate. Its portfolio has grown to 231 projects.

- **Agent Substrate (Google).** Donated to CNCF together with gVisor and OpenRL. It provides zero-trust sandboxing for very large numbers of agents on Kubernetes: idle agents are suspended and later resumed onto warm worker pods. Every actor runs inside a dedicated gVisor or Cloud Hypervisor microVM sandbox; plain Linux containers are not supported. kagent now uses it as its default execution backend.
- **OpenShell (NVIDIA).** Accepted into CNCF on September 26, 2026.
  - It instruments the kernel to enforce policy on every file access, system call and network connection, and formally verifies what a policy change would allow before applying it.
  - Agents get credential placeholders; real credentials are injected only into requests bound for approved endpoints.
  - All egress except the supervisor channel is denied.
  - The project is young (v0.1.x, moving to Cedar policies), so pin a version.
- **Nitro Sandboxes (AWS).** Launched November 9, 2026.
  - Each opted-in EKS pod, ECS task or EC2 workload gets its own hardware-isolated microVM at no extra charge.
  - On EKS Auto Mode you opt in with `runtimeClassName: isolated-sandbox`. On ECS it requires ECS Managed Instances.
  - GPU pods can't be sandboxed.
  - Vendor samples suggest roughly 1 s warm starts and 5–6 s cold starts.
- **Also notable:** llm-d 1.0 (Oct 20, 2026), KubeVirt graduated, Broadcom contributed a "VM API" to the Sandbox, and the Gateway API Inference Extension reached GA.

*What this means:* "I can run untrusted agents with least-privilege egress, credential brokering and per-agent cost tracking" is a near-perfect portfolio claim right now.

**Non-human identity is the new IAM frontier.** NIST's NCCoE published a concept paper on software and AI agent identity on February 5, 2026, which drew feedback from 600+ commenters. In September 2026 NIST named agents in the software development lifecycle as its first implementation use case. On October 27, 2026 it published 10 design tenets for agent identity management: delegated access, revocable permissions and audit trails. That maps directly onto:
- GitHub OIDC → AWS
- EKS Pod Identity
- SPIFFE/SPIRE IDs for agents
- short-lived scoped tokens

**Supply-chain attacks now go *through* the "secure" path.**
- **LiteLLM, March 24, 2026.** Versions 1.82.7 and 1.82.8 were backdoored via the Trivy dependency in LiteLLM's own CI security-scanning workflow.
- **LiteLLM, October 21, 2026.** Version 1.107.0 shipped a credential stealer to both PyPI and Docker images, using Python startup hooks (`.pth` / `sitecustomize.py`). It ran even if the app never imported LiteLLM.
- **Shai-Hulud, May 11, 2026 (TanStack wave).** OIDC tokens were read from GitHub Actions runner memory and exchanged for npm publish tokens. The malicious packages carried *valid* SLSA provenance.

*What this means:* SBOMs and signing alone are not enough. Show defenses that assume provenance can be minted by a compromised pipeline:
- pin actions by SHA and images by digest
- add dependency cooldowns
- block install scripts
- restrict which workflows and refs can mint OIDC tokens
- keep long-lived secrets off runners
- run egress-restricted builds

**AWS is splitting compute into many shapes, which gives the "Lambda vs. cluster" debate real numbers.**
- **Lambda Managed Instances pricing:** $0.20 per million requests, plus a 15% premium on the EC2 on-demand price, plus the EC2 cost itself. Discounts apply only to the EC2 part.
- **One AWS Java benchmark:** above roughly 9 requests per second steady-state, the fixed instance cost beats standard Lambda. That is one benchmark, not a rule.
- **re:Invent 2026 serverless guide:** describes three Lambda execution models (durable functions, Managed Instances, Lambda MicroVMs). It quotes Honeycomb reporting roughly 7.5× lower cost on Managed Instances for steady traffic; that's a customer claim.
- **EKS Auto Mode** gained Gateway API support on Oct 28, 2026.

**ingress-nginx is dead; Gateway API is the default.** The community controller was retired in March 2026, and ingress2gateway 1.0 shipped on March 20. A January 2026 Kubernetes committee statement put ingress-nginx usage at about 50% of cloud native environments.

**AI-assisted security and testing are becoming AWS products.**
- **AWS Continuum for code vulnerabilities (GA):** validates exploitability in a sandbox and opens fix PRs. A human approves each fix.
- **AWS Emulator (GA Nov 11, 2026):** local, free, CC0-licensed, covers 200+ services, and comes with a published list of known discrepancies.

Use Continuum as a pattern (agent proposes, human approves) and the Emulator for the inner loop only.

**The "SaaSpocalypse" makes build-vs-buy a live architecture question.** Software stocks sold off sharply in February 2026. Loss estimates range from about $285B in 48 hours to more than $1T in a week, depending on source and window. A credible lab replaces one paid SaaS with self-hosted OSS and includes an honest TCO with on-call cost.

**FinOps for AI is table stakes.**
- State of FinOps 2026: 98% of respondents manage AI spend, up from 63% in 2025.
- FOCUS 1.3 (ratified Dec 4, 2025) adds split cost allocation for shared resources such as Kubernetes clusters.
- Per-team, per-agent token chargeback in a FOCUS-shaped export is a rare differentiator.

**re:Invent 2026** runs Nov 30–Dec 4. Design the labs so new launches can be added as "Ideas" rather than forcing a redesign.

### 2. The 2026 hiring market

- **Depth over breadth, with real usage.** Hiring managers read GitHub carefully and look for something other engineers actually used. Tutorial clones and AI-scaffolded apps look identical. Aim for 3–5 projects you can discuss for 20 minutes each.
- **Interviews test operations stories.** A sev-1 walkthrough is a common screen. Documented game days give you more material.
- **How AI fluency is evaluated.** (a) Disciplined AI-assisted work is visible in the repo: agent configs, review gates, evals. (b) You run agents as production services with SLOs, budgets and blast-radius limits. "Agent Reliability Engineer" is emerging as a title.
- **Certifications.**
  - **AWS SAA** is the main filter for SA and Cloud roles; **CKA** for Platform and SRE.
  - CNCF launched **CKNE** on Nov 10, 2026. **KAIA** and **CKIE** are planned for 2027.
  - Suggested order: SAA in Dec–Jan, CKA in Q1 2027, then watch CKIE.
- **Pay.** Mid-level US Platform Engineer total comp is about $145k–$185k. Anduril's Costa Mesa postings show $166k–$222k (senior) and $191k–$253k (staff). Check Levels.fyi or the posted ranges, which California requires.

### 3. Defense tech (SoCal) vs. primes

- **Modern tooling: yes.** Anduril's "Classified Platform Engineer" role uses GitOps CI/CD on Kubernetes that scans and signs, and produces accreditation evidence.
- **The gate is eligibility, not tooling.** Postings require TS eligibility, an active Secret clearance, or US-person status.
- **Airgap is central there.** Defense Unicorns' UDS Core 1.0 is built on Zarf. One optional lab (Lab D) is enough signal.
- **IDF reserve service.** Guideline C (Foreign Preference) lists foreign military service as potentially disqualifying. DOHA decisions go both ways. Ongoing reserve obligations are likely more problematic than completed past service, and Guideline B (foreign influence) usually comes up too. **Don't build the plan around a clearance.** Get a clearance attorney's read before pursuing that path.

### 4. Planning format

Use independent labs, one README template, decisions written inline, and a Now/Next/Later/Ideas board. Improvements:
1. Put the proof first: a GIF plus one command to reproduce it.
2. Include a cost receipt in every lab.
3. Use "Why not X?" callouts instead of ADRs.
4. Make the root README a 60-second tour.
5. Keep the board strict: at most 2 items in Now, and new trends go to Ideas.

## The Runway design

**Scenario:** a fictional 30-engineer LA company with four workloads:
- a marketing site with a quote form
- a catalog/orders API
- a nightly batch job
- a support-triage AI agent

Its pain points are manual deploys, shared long-lived keys, unknown cloud and AI bills, and nobody knowing which agent did what.

**Lab menu:** see the root README and the Linear projects (P-YAA-2 to P-YAA-14).

**Suggested order:** 0 → 1 → 2 → 3 → 5 → 7 (about 10–12 weekends), then 6, 8 and 10.

**Cost guardrails:**
- EKS control plane: $0.10/hour (stay off extended support, which costs $0.60/hour).
- Auto Mode fee: about 12% on top of EC2.
- NAT Gateway: $0.045/hour plus $0.045/GB, and partial hours bill as full hours.
- Public IPv4: $0.005/hour per address.
- A 4-hour demo costs roughly $2–5.
- Avoid NAT where possible. Delete load balancers before the cluster.
- Budgets at $5/$15/$30, Cost Anomaly Detection, a nightly reaper, and `make up` / `make down` / `make nuke`.
- Front-load the AWS-heavy labs (2, 3, 5, 7) while free-tier credits remain.

## Resume and interview framing

- **Positioning:** "Platform engineer who turns manual, fragile environments into self-service, secure, cost-visible platforms — now for services *and* AI agents."
- **Bullets:** carry numbers from cost receipts and proofs.
- **Credibility bridge:** pair each portfolio bullet with a bank analogue.
- **Stories:** prepare three 5-minute stories: the game day, the break-even decision, and the agent red-team.
- **AI section:** add a short "How I used AI on this repo" section.

## Caveats

- Many 2026 details come from vendor docs or secondary coverage. OpenShell is v0.1.x, and Agent Substrate is pre-1.0 outside GKE.
- SaaSpocalypse figures vary by source and time window.
- re:Invent 2026 may change AWS-specific details.
- Clearance guidance is informational, not legal advice.
- **Unverified leads**, to check before citing (Linear YAA-15):
  - SOCI for Lambda Managed Instances
  - ECS Spot consolidation
  - Security Hub SBOM inventory
  - Cloudsmith agent-skills registry
  - IETF AIMS
  - most of the KubeCon graduations (OpenTelemetry, NATS, Kubeflow, Buildpacks, Karmada) and CloudNativePG moving to incubation

KubeVirt's graduation and llm-d 1.0 were confirmed.

## Key sources
- CNCF KubeCon NA 2026 milestones: https://www.cncf.io/announcements/2026/11/10/cncf-hits-major-milestones-with-global-community-growth-record-industry-investment-and-a-new-generation-of-projects-to-build-ai-systems-in-production/
- OpenShell: https://www.cncf.io/projects/openshell/ · https://docs.nvidia.com/openshell/about/architecture
- Agent Substrate: https://github.com/agent-substrate/substrate
- Nitro Sandboxes coverage: https://runtimewire.com/article/aws-nitro-sandboxes-eks-ecs-ec2-hardware-isolated-vms
- NIST agent identity comments: https://www.nist.gov/news-events/news/2026/09/comments-software-and-agentic-ai-identity-concept-paper
- LiteLLM March 2026 incident: https://docs.litellm.ai/blog/security-update-march-2026
- Shai-Hulud: https://socket.dev/glossary/shai-hulud
- Lambda Managed Instances: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances.html · https://aws.amazon.com/blogs/compute/eliminating-java-cold-starts-with-aws-lambda-managed-instances/
- AWS serverless re:Invent 2026 guide: https://aws.amazon.com/blogs/compute/your-serverless-attendees-guide-to-aws-reinvent-2026/
- AWS Continuum GA: https://aws.amazon.com/blogs/aws/aws-continuum-for-code-vulnerabilities-is-now-generally-available/
- AWS Emulator: https://siliconangle.com/2026/11/11/amazons-open-source-aws-emulator-lets-developers-validate-their-code-locally-without-the-cloud/
- Forrester on SaaS: https://www.forrester.com/blogs/saas-as-we-know-it-is-dead-how-to-survive-the-saas-pocalypse/
- CKNE launch: https://cloudnativenow.com/kubecon-cloudnativecon-north-america-2026/cncf-launches-certified-kubernetes-network-engineer-ckne-certification/
- Anduril Classified Platform Engineer: https://jobs.8vc.com/companies/anduril/jobs/97291588-classified-platform-engineer
- UDS Core 1.0: https://defenseunicorns.com/resources/announcing-uds-core-1-0/
- Foreign military service and clearances: https://kcnfdc.com/blog/bearing-arms-for-a-foreign-country/
- EKS pricing: https://aws.amazon.com/eks/pricing/ · VPC pricing: https://aws.amazon.com/en/vpc/pricing/
