---
verdict: adopted
area: supply-chain
labs: ['01', '07']
verified: true
updated: 2026-11-13
sources:
  - https://docs.litellm.ai/blog/security-update-march-2026
---

# Litellm Compromises 2026

**What it is:** LiteLLM was backdoored twice in 2026: in March via Trivy in its own CI, and in Oct 1.107.0 via a `.pth` startup-hook credential stealer in both PyPI and Docker images.

**Why it matters for Runway:** The motivating incident for Lab 01's payload replay and for Lab 07's choice of gateway.

**Next step:** see the labs above.
