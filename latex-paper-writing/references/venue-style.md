# Venue Style Rules

Format conventions and constraints per venue. Always check the actual CFP for the year — limits change. These templates ship with:

| Venue | Class | Columns | Anonymous? | Typical page limit |
|---|---|---|---|---|
| IEEE conference | `IEEEtran` (conference) | 2 | venue-specific | 10 content + 2 refs (varies: 6–12) |
| IEEE journal | `IEEEtran` (journal) | 2 | no | none (expect thoroughness) |
| ACM sigconf | `acmart` (sigconf) | 2 | `[anonymous]` option | 10–12 incl. refs (varies) |
| arXiv preprint | `article` | 1 | no | none |
| AAS journal (ApJ/AJ/ApJL/ApJS/PSJ) | `aastex701` | 2 (`twocolumn`) | `anonymous` option (dual-anonymous) | word-count based (letters tightest) |

## IEEE conference

- 10pt Times, two columns, set entirely by the class — do not fight `\IEEEtran` with geometry or font packages.
- Page limits vary widely (6, 8, 10 + reference pages) — the CFP for your specific conference is authoritative.
- Abstract ≤ 250 words; keywords 3–6 in `IEEEkeywords`.
- Bibliography: `\bibliographystyle{IEEEtran}` + the `cite` package (already in the template). Citations render as `[1]`, `[2], [5]–[7]` — use them as noun support ("methods [3] achieve..."), never as the noun itself ("[3] achieves...").
- Tables: caption ABOVE, booktabs style (no vertical lines). Figures: caption BELOW, referenced as "Fig. 1" (the class abbreviates automatically).
- Double-blind venues (growing minority of IEEE conferences): remove the author block entirely, blank out `\thanks`, strip acknowledgments, and anonymize self-references in third person ("Prior work [1] showed..." not "our prior work").
- Camera-ready vs submission: submission PDFs often need no copyright block; camera-ready adds `\IEEEpubid` / copyright lines per the proceedings chair's instructions.

## IEEE journal

- Journal mode: abstract + index terms set inside the first column; running heads via `\markboth`; first paragraph opens with `\IEEEPARstart{F}{irst}` drop cap (see the comment in the template's `main.tex`).
- No hard page limit, but reviewers expect completeness: broader related work, more experiments, often an appendix. A journal submission that is just the conference PDF resubmitted is usually rejected for insufficient extension.
- Authors may be asked to supply a graphical abstract and bios/photos at acceptance — leave space in the author block thinking.

## ACM (acmart)

- The class enforces almost everything (fonts, spacing, CCS, reference format). **Do not** add geometry/setspace/fontsize hacks — TAPS will reject the source.
- **Font dependency**: `acmart` uses the Linux Libertine fonts with microtype font expansion. If compilation dies with `pdfTeX error (font expansion): auto expansion is only possible with scalable fonts`, the TeX installation lacks them — install `texlive-fonts-extra` (Debian/Ubuntu) or `tlmgr install libertine libertinust1math` (TeX Live).
- Abstract, `\keywords{}`, and CCS concepts (`\begin{CCSXML}...\end{CCSXML}` + `\ccsdesc`) go **before `\maketitle`** — this is the main structural difference from IEEE.
- CCS concepts must be real: generate at <https://dl.acm.org/ccs> and paste both the XML block and the `\ccsdesc` lines.
- Submission: `\documentclass[sigconf,review,anonymous]` for double-blind (line numbers from `review`, anonymization from `anonymous`). Camera-ready: drop those options; fill in copyright/DOI blocks per the publication chair.
- References: `ACM-Reference-Format`, which requires DOI/name fields in `.bib` entries to render fully — see `bibtex-guide.md`.
- Page limits for ACM conferences commonly INCLUDE references — check the CFP; over-length pages may be purchasable.

## arXiv

- Single column, hyperlinked (`hyperref`, blue links are conventional). No limit; readers skim on screen, so front-load results in the abstract.
- arXiv is not peer review: posting a preprint is fine before/with submission to most (not all — check policies, e.g., some IEEE journals differ) venues, but claim nothing in the abstract you cannot show.
- Use `plainnat`/`natbib` numeric style (in the template). Include DOIs/URLs in `.bib` entries — arXiv readers follow them.
- Update the listing with a new version rather than deleting; mention substantive changes in the comments field.

## AAS journals (ApJ, AJ, ApJL, ApJS, PSJ)

- **Structure differs fundamentally from CS venues** — use the venue's own chapters (`assets/aas-journal/chapters/`): Introduction (carries the literature review), Data, Method, Validation, Results, Discussion, Summary. No Related Work section, no Threats to Validity.
- `aastex701.cls` is NOT in TeX distributions — the class and `aasjournalv7.bst` are bundled in the scaffold; keep them next to the manuscript when submitting.
- Class options: `linenumbers` is **mandatory** for AAS submissions; `twocolumn` for the published look, `manuscript` for double-spaced review drafts; `anonymous` for dual-anonymous review (auto-hides authors, acknowledgments); `trackchanges` + `\added`/`\replaced`/`\deleted` for revisions.
- Front matter: each author needs `\author` + `\affiliation` + `\email`; optional ORCID metadata in `\author[orcid=...,gname=...,sname=...]{}`. `\shorttitle`/`\shortauthors` set running heads; `\received`/`\revised`/`\accepted` and `\submitjournal` at submission time.
- Keywords are **Unified Astronomy Thesaurus** concepts via `\keywords{\uat{Galaxies}{573}}` (astrothesaurus.org); they are also selected in the submission system.
- Length is word-count based (quanta), not page-based — letters (ApJL) have the tightest limits; check the current AAS Author Guide for numbers.
- After the Summary: `acknowledgments` environment, then `\facilities{...}` and `\software{...}` (both keyword-checked at copy editing — use real facility keywords, e.g. `\facilities{DESI}`), then `\appendix` for long tables/derivations.
- Citations are author-year natbib: `\citet` textual, `\citep` parenthetical, `\citealp` inside already-parenthesized text. Keys conventionally use ADS bibcodes (see `bibtex-guide.md`).
- Data availability is expected: publish catalogs as machine-readable tables (CDS/AAS hosting) and state software versions/links in `\software{}`.

## Anonymization checklist (any double-blind venue)

1. Author block empty; no `\thanks` footnotes leaking grants/institutions.
2. Acknowledgments section removed.
3. Self-citations in third person, unmarked ("Prior work [7]...").
4. PDF metadata scrubbed (author field in the PDF properties).
5. Repository/GitHub links anonymized (Anonymous 4 Open / anonymous.4open.science) or removed.
6. File names and `\label`s don't contain author names (they leak in the PDF source users can download on arXiv later — harmless for review, but tidy).
