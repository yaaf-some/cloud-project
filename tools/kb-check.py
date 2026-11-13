#!/usr/bin/env python3
"""Keep Runway's knowledge base small and honest.

Checks (rules in kb/index.md):
  1. kb/ holds at most MAX_KB_FILES files.
  2. No markdown file in kb/ or labs/ exceeds MAX_LINES lines.
  3. Every file in kb/ (except index.md) is linked from kb/index.md.
  4. kb/radar.md has at most MAX_RADAR_ROWS table rows.
  5. No session/meeting/status notes in the repo.
  6. Each lab's README status matches the emoji in the root README lab table.

Standard library only. Exit code 1 if any check fails.
Usage: python3 tools/kb-check.py [repo_root]
"""
import re
import sys
from pathlib import Path

MAX_KB_FILES = 8
MAX_LINES = 250
MAX_RADAR_ROWS = 25
STATUS_EMOJI = {"done": "✅", "now": "🔨", "next": "💡", "idea": "💡"}

root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
kb = root / "kb"
problems: list[str] = []

kb_files = sorted(p for p in kb.rglob("*") if p.is_file())
if len(kb_files) > MAX_KB_FILES:
    problems.append(f"kb/ has {len(kb_files)} files (max {MAX_KB_FILES}). Merge, move into a lab README, or delete.")

for p in list(kb.rglob("*.md")) + list((root / "labs").rglob("*.md")):
    n = len(p.read_text(encoding="utf-8").splitlines())
    if n > MAX_LINES:
        problems.append(f"{p.relative_to(root)} is {n} lines (max {MAX_LINES}). Cut it or split it by lab.")

index = (kb / "index.md").read_text(encoding="utf-8") if (kb / "index.md").exists() else ""
for p in kb_files:
    rel = p.relative_to(kb).as_posix()
    if rel == "index.md":
        continue
    if rel not in index and p.name not in index:
        problems.append(f"kb/{rel} is not linked from kb/index.md. Link it or delete it.")

radar = kb / "radar.md"
if radar.exists():
    rows = [l for l in radar.read_text(encoding="utf-8").splitlines() if l.startswith("|")]
    data_rows = max(0, len(rows) - 2)  # minus header and separator
    if data_rows > MAX_RADAR_ROWS:
        problems.append(f"kb/radar.md has {data_rows} rows (max {MAX_RADAR_ROWS}). Move adopted items into labs and delete dropped ones.")

for p in root.rglob("*.md"):
    if ".git" in p.parts:
        continue
    if re.search(r"(^|/)(sessions?|meetings?|standups?|status)(/|$)", p.relative_to(root).as_posix()):
        problems.append(f"{p.relative_to(root)} looks like a session/status note. Put handoffs in the Linear issue and the PR instead.")

readme = (root / "README.md").read_text(encoding="utf-8")
for lab_readme in sorted((root / "labs").glob("*/README.md")):
    text = lab_readme.read_text(encoding="utf-8")
    m = re.search(r"^status:\s*(\w+)", text, re.M)
    if not m:
        problems.append(f"{lab_readme.relative_to(root)} has no status in its frontmatter.")
        continue
    folder = lab_readme.parent.name
    row = next((l for l in readme.splitlines() if f"labs/{folder}/" in l), None)
    want = STATUS_EMOJI.get(m.group(1))
    if row is None:
        problems.append(f"labs/{folder} is missing from the root README lab table.")
    elif want and want not in row:
        problems.append(f"labs/{folder}: status '{m.group(1)}' but the root README shows something else (expected {want}).")

if problems:
    print("kb-check: FAIL")
    for p in problems:
        print(f"  - {p}")
    sys.exit(1)
print(f"kb-check: OK ({len(kb_files)} kb files, radar within limit, lab table in sync)")
