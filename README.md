# overleaf-latex-skill

A Claude Code skill for LaTeX research-paper writing — an Overleaf-style paper workflow in your terminal. It scaffolds a paper project for IEEE conference, IEEE journal, ACM, arXiv, or AAS/astronomy journals (AASTeS); drafts and revises sections; manages BibTeX citations; compiles the PDF and diagnoses LaTeX errors; and runs pre-submission checks.

Two layers:

- **`latex-paper-writing/`** — the skill itself. Its operating manual is [`latex-paper-writing/SKILL.md`](latex-paper-writing/SKILL.md).
- **`.claude/skills/latex-paper-writing`** — a relative symlink wiring the skill into this repo, so Claude Code picks it up whenever you work here.

To use the skill in other projects, symlink it into your personal skills:

```bash
ln -s "$(pwd)/latex-paper-writing" ~/.claude/skills/latex-paper-writing
```

Requires a TeX installation (`pdflatex`, `bibtex`) and bash. Verify with `latex-paper-writing/scripts/check_latex_env.sh`. Note: the ACM template additionally needs the Libertine fonts (`texlive-fonts-extra` on Debian/Ubuntu).

## Layout

```
├── README.md                   # this file
├── .claude/skills/latex-paper-writing -> ../../latex-paper-writing
└── latex-paper-writing/        # the skill
    ├── SKILL.md                # when the skill triggers + the workflows it runs
    ├── assets/
    │   ├── chapters-shared/    # CS/ML section skeletons w/ paragraph-level writing guides
    │   ├── references.bib      # sample BibTeX database (shared)
    │   ├── ieee-conference/    # IEEEtran conference template (main.tex + abstract.tex)
    │   ├── ieee-journal/       # IEEEtran journal template
    │   ├── acm-sigconf/        # acmart sigconf template
    │   ├── arxiv/              # single-column article preprint template
    │   └── aas-journal/        # AASTeS v7 (ApJ/AJ/...): own chapter set + bundled cls/bst
    ├── scripts/
    │   ├── new_paper.sh        # scaffold: new_paper.sh <venue> <dir> [--title "..."]
    │   ├── compile.sh          # compile: compile.sh <dir> [quick|full] — extracts real errors from the log
    │   └── check_latex_env.sh  # diagnose a missing/broken TeX installation
    └── references/             # loaded on demand (see SKILL.md's table)
        ├── writing-guide.md    # per-section writing methodology + revision checklist
        ├── venue-style.md      # per-venue format rules, page limits, anonymization
        ├── bibtex-guide.md     # citations: sourcing real entries, hygiene, bug table
        └── common-errors.md    # compile error meanings, clean rebuild, TeX setup
```

## Quick start (without Claude)

```bash
latex-paper-writing/scripts/new_paper.sh ieee-conference ~/papers/my-paper --title "Frobnicated Learning for Widgets"
latex-paper-writing/scripts/compile.sh ~/papers/my-paper      # verify the baseline compiles
$EDITOR ~/papers/my-paper/chapters/                           # each skeleton explains what to write
latex-paper-writing/scripts/compile.sh ~/papers/my-paper full # after adding citations / before shipping
```
