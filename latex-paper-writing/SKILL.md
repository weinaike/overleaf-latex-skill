---
name: latex-paper-writing
description: End-to-end assistant for writing research papers in LaTeX. Scaffolds a new paper project for IEEE conference, IEEE journal, ACM, arXiv, or AAS/astronomy journal (ApJ, AJ, AASTeS) venues; drafts and revises sections (abstract, introduction, related work, data, methodology, evaluation/validation, results, discussion, conclusion); manages BibTeX citations; compiles the PDF and diagnoses LaTeX errors; and runs pre-submission checks. Use this skill whenever the user mentions writing, drafting, or revising a paper or any section of one, starting a paper project, adding or fixing citations, LaTeX compile errors, page limits, camera-ready preparation, or submitting to a conference or journal — even if they never say the word "LaTeX".
---

# LaTeX Paper Writing

Help researchers go from "I have an idea" to a submitted PDF. This skill bundles three things:

- **`assets/`** — paper scaffolds for five venues (IEEE conference, IEEE journal, ACM sigconf, arXiv, AAS journals), plus section skeletons with paragraph-level writing guidance baked in as comments. Most venues share the CS/ML chapter set (`chapters-shared/`); `aas-journal` ships its own astronomy structure (data → method → validation → results → discussion → summary) plus the AASTeS class files.
- **`scripts/`** — `new_paper.sh` (scaffold a project), `compile.sh` (compile with readable error extraction), `check_latex_env.sh` (diagnose a broken TeX installation).
- **`references/`** — deep-dive guides loaded only when needed: writing methodology, venue style rules, BibTeX hygiene, error troubleshooting.

Read `references/` files on demand — do not load them all upfront. The table at the bottom says when to read what.

## Workflow A: Start a new paper

1. Determine the venue. If the user did not name one, ask — the venue decides the template. Available: `ieee-conference`, `ieee-journal`, `acm-sigconf`, `arxiv`, `aas-journal` (AAS journals: ApJ/AJ/ApJL/ApJS).
2. Scaffold the project:
   ```bash
   <skill-dir>/scripts/new_paper.sh <venue> <target-dir> --title "Paper Title"
   ```
   This copies the venue's `main.tex` + `abstract.tex`, the section skeletons into `chapters/` (shared CS/ML set, or the venue's own if it bundles one), the sample `references.bib`, a `figures/` directory, and any support files the venue ships (e.g. `aastex701.cls` for `aas-journal`).
3. Fill in the real title and author block in `main.tex` (never leave "Your Paper Title Here" or placeholder authors in place).
4. Immediately verify the baseline compiles: `scripts/compile.sh <target-dir>`. Compiling an empty skeleton first isolates environment problems from content problems — if this fails, fix the environment before writing a single sentence.

## Workflow B: Draft and revise content

Section files live in `chapters/` and are wired into `main.tex` via `\input`. Each skeleton contains a paragraph-level outline in comments — follow it; it encodes the standard moves reviewers expect (e.g., a four-move introduction; RQ-driven evaluation in CS venues; the astronomy data→validation→discussion arc in AAS journals). Before drafting any section, read `references/writing-guide.md` for that section's methodology and common mistakes.

While writing:

- **Label discipline**: every section/subsection/figure/table/equation gets a `\label` with the conventional prefix (`sec:`, `subsec:`, `fig:`, `tab:`, `eq:`, `alg:`), and every label is referenced somewhere via `\ref`/`eqref`. Unreferenced floats and dangling references are review defects.
- **Figures** go in `figures/`; reference them as `\includegraphics[width=\linewidth]{figures/...}`.
- **Compile after every section**: `scripts/compile.sh <dir>` (quick mode). LaTeX errors compound — a mistake caught after 20 lines is trivial, caught after 20 pages it is archaeology.
- The paper's language is English. Keep sentences short, claims specific, and hedge only where evidence is genuinely limited.

## Workflow C: Citations

All references live in `references.bib`. Cite as `\cite{key}` — except in `aas-journal`, which uses natbib author-year style: `\citet{key}` when the citation is part of the sentence ("Hubble 1926 showed..."), `\citep{key}` when parenthetical.

- **Never fabricate a bibliography entry.** If a citation's details are uncertain, insert the entry with a `% TODO: verify` comment and tell the user to confirm it. A wrong citation is worse than a missing one — it is a credibility defect reviewers remember.
- After adding new bib entries or new `\cite` commands, run a full compile (`compile.sh full`) — quick mode leaves citations unresolved.
- Read `references/bibtex-guide.md` when creating entries by hand or debugging citation problems.

## Workflow D: Compile and debug

```bash
scripts/compile.sh <dir>          # quick: single pdflatex pass
scripts/compile.sh <dir> full     # full: pdflatex → bibtex → pdflatex ×2
```

`compile.sh` extracts real errors from the `.log` (lines starting with `!`, with file:line info) instead of dumping the whole log. On failure:

1. Read the **first** error, not the last — LaTeX cascades; error N+1 is usually a symptom of error N.
2. If the error is not self-evident, look it up in `references/common-errors.md`.
3. Weird persistent state ("it should work but doesn't") → clean aux files and full-compile again; `compile.sh` explains how.
4. If `pdflatex` itself is missing, run `scripts/check_latex_env.sh` and follow its per-OS install advice.

## Workflow E: Pre-submission check

Before telling the user the paper is ready, verify:

1. **Placeholders gone**: `grep -rn -iE "TODO|placeholder|Your Paper Title|example\.com|XXX" <dir>` returns nothing.
2. **All references resolved**: full compile, then the `.log` contains no `undefined references` / `Citation .* undefined` warnings.
3. **Page limit respected** (see `references/venue-style.md` for per-venue limits; IEEE conference is typically 10 pages + 2 reference pages — check the CFP for the actual number).
4. **Final artifact**: end with a full compile so the shipped PDF has all cross-references resolved.

## Reference files

| File | Read when... |
|---|---|
| `references/writing-guide.md` | Drafting or revising any section — methodology, structure, common mistakes per section |
| `references/venue-style.md` | Questions about a venue's format rules, page limits, anonymity, camera-ready differences |
| `references/bibtex-guide.md` | Creating bib entries, fixing citation rendering, choosing entry types |
| `references/common-errors.md` | A compile error you don't recognize, or TeX environment problems |
