# AGENTS.md

Guidance for coding agents (Codex, Gemini CLI, Cursor, …) working in this repository. For Claude Code the skill is already wired up via `.claude/skills/latex-paper-writing`.

## What this repo is

A single-skill repo: **latex-paper-writing**, an end-to-end LaTeX research-paper writing skill following the open Agent Skills format. The source of truth is `latex-paper-writing/`:

- `SKILL.md` — the operating manual: trigger conditions, Workflows A–E (scaffold / draft / citations / compile / pre-submission), and the table saying which `references/` file to read when
- `assets/` — venue templates (IEEE conference, IEEE journal, ACM sigconf, arXiv, AAS journal) + section skeletons
- `scripts/` — `new_paper.sh` (scaffold), `compile.sh` (compile + readable error extraction), `check_latex_env.sh` (TeX install diagnosis)
- `references/` — deep-dive guides the skill loads on demand; never load them all at once

## Rules

- `.claude/skills/latex-paper-writing` is a relative symlink — never edit through it; edit `latex-paper-writing/` directly.
- Keep the skill body agent-neutral: no Claude-specific tool names or phrasing in anything under `latex-paper-writing/` (the same SKILL.md also runs under Codex and Gemini CLI via `install.sh`).
- Scripts are plain bash with `set -euo pipefail` and no non-core dependencies — keep them that way.

## Verifying changes

Scaffold and compile one venue end-to-end:

```bash
latex-paper-writing/scripts/new_paper.sh ieee-conference /tmp/lpw-test
latex-paper-writing/scripts/compile.sh /tmp/lpw-test
```

Requires `pdflatex`/`bibtex` (diagnose with `check_latex_env.sh`).
