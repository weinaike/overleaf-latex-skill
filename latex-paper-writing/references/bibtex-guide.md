# BibTeX & Citations

How to build and maintain the `references.bib` database, and fix citation problems.

## Table of contents

- [Getting real entries](#getting-real-entries)
- [Entry anatomy and types](#entry-anatomy-and-types)
- [Style hygiene](#style-hygiene)
- [Keys](#keys)
- [How the compile pipeline uses the .bib](#how-the-compile-pipeline-uses-the-bib)
- [Common citation bugs](#common-citation-bugs)

## Getting real entries

**Never invent an entry.** A fabricated citation (wrong year, wrong authors, nonexistent DOI) is a permanent credibility hit when a reviewer checks — and reviewers check the citations closest to your claims. Get entries from:

1. **DBLP** (dblp.org) — cleanest BibTeX for CS; preferred source.
2. **NASA ADS** (ui.adsabs.harvard.edu) → Export → BibTeX — the source for astronomy; ADS exports use bibcode keys (`1926ApJ....64..321H`) and braced surnames (`{Hubble}, Edwin P.`), which the `aas-journal` template follows. ADS "also referenced" lists are also the fastest way to find the canonical citation for a method.
3. **Google Scholar** → Cite → BibTeX — good fallback; fix its ALL-CAPS titles.
4. **The publisher page** (ACM DL, IEEE Xplore) — most accurate DOIs.
5. **arXiv** — use `@misc` with `eprint = {2401.12345}` and `archivePrefix = {arXiv}`; if a published version exists, cite THAT instead.

If details cannot be verified (you only remember "a 2019 paper by X about Y"), insert the entry with `% TODO: verify` and tell the user to confirm before submission.

## Entry anatomy and types

```bibtex
@inproceedings{smith2022example,
  author    = {Smith, John and Doe, Jane and Third, Anne},
  title     = {An Example Conference Paper},
  booktitle = {Proceedings of the 2022 IEEE International Conference on Example},
  year      = {2022},
  pages     = {1--6},
  publisher = {IEEE},
  doi       = {10.1109/EXAMPLE.2022.123456}
}
```

- **author**: `Last, First and Last, First` — "and" (not commas) separates authors. Wrap a list name in braces: `{Deep Learning Working Group}`.
- **title**: protect acronyms/capitalization with braces: `{IEEE}`, `{LSTM}`, `{B}ayesian`. Styles otherwise downcase titles.
- Pick the type that matches: `@article` (journal), `@inproceedings` (conference/workshop), `@book`, `@inbook` (chapter), `@phdthesis`/`@mastersthesis`, `@techreport`, `@misc` (arXiv, blogs, datasets, software). Software: `@misc` with `howpublished = {\url{...}}` and a version/date.
- ACM's `ACM-Reference-Format` wants `doi` populated; IEEEtran mostly ignores it in print. Include `doi`/`url` on everything — costs nothing, helps later.

## Style hygiene

- Page ranges use en-dashes: `pages = {123--135}`.
- Month abbreviations unquoted: `month = jun`.
- One entry, one purpose: if you cite the arXiv version AND the published version, that's usually a mistake — cite the published one.
- Delete uncited entries before submission (see the check in the skill's pre-submission workflow; uncited entries do not appear in the output with these styles, but they rot the file).
- Keep entries alphabetically or by key-order — arbitrary order makes merges painful.

## Keys

Convention: `firstauthorYEARkeyword` — `smith2022example`. Lowercase, no spaces/colons (colons break some tools). Keys are invisible in the output; choose for grep-ability, not beauty. Astronomy convention (followed by the `aas-journal` template) is the ADS bibcode of the first-author paper: `2015MNRAS.446.3943M` — cryptic-looking but standard, and paste-compatible with ADS exports. When renaming a key, grep the whole `chapters/` tree for `\cite{oldkey}` — a renamed-but-unupdated key becomes an undefined citation.

**Author-year venues (aas-journal)** render `\citet{key}` as "Meert et al. (2015)" and `\citep{key}` as "(Meert et al. 2015)". This makes author fields load-bearing: keep surnames braced (`{de Souza}, Ronaldo E.`) so "de" never gets parsed as a given-name particle, and protect collaborations (`{Deep Learning Working Group}`).

## How the compile pipeline uses the .bib

Why "full compile" is four passes:

1. `pdflatex` #1 — writes every `\cite{key}` into `main.aux`.
2. `bibtex` — reads `main.aux` + `references.bib`, produces `main.bbl` (the formatted bibliography) and reports errors in `main.blg`.
3. `pdflatex` #2 — includes the `.bbl`, writes where each citation number lands.
4. `pdflatex` #3 — resolves the numbers into the text.

This is why a quick single pass after adding citations shows `[?]` — steps 2–4 have not run. Use `scripts/compile.sh <dir> full`.

## Common citation bugs

| Symptom | Cause | Fix |
|---|---|---|
| `[?]` in the PDF | BibTeX passes not run after adding a `\cite` | full compile |
| `Citation 'x' undefined` in log | key typo, or entry missing from `.bib` | match key spelling exactly (case-sensitive) |
| Entry silently absent from bibliography | uncited — bibtex only includes cited entries | cite it, or check for typo'd key |
| Two entries merged into one line | missing comma at the end of a field | check the line before the reported one |
| `I'm skipping whatever remains of this entry` | unbalanced brace in the entry | count `{`/`}`; usually an unbraced `%` or `&` |
| Wrong author rendering ("J. Smith" vs intended) | missing `and` between authors | use `Last, First and Last, First` |
| Title capitalization lost | style downcases titles | brace the words: `{LSTM}` |
| Same paper twice as [3] and [7] | duplicate entry under two keys | merge to one key |
