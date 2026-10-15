# LaTeX Compilation Troubleshooting

How to read errors, the common ones, and environment problems. `scripts/compile.sh` extracts the error lines for you — this file explains what they mean.

## Table of contents

- [How to read a LaTeX error](#how-to-read-a-latex-error)
- [Common errors](#common-errors)
- [Reference/citation warnings](#referencecitation-warnings)
- ["It should work but doesn't" — clean rebuild](#it-should-work-but-doesnt--clean-rebuild)
- [TeX environment problems](#tex-environment-problems)

## How to read a LaTeX error

Open `main.log` and find the **first** line starting with `!`. LaTeX cascades: after a real error, dozens of follow-on errors appear, and fixing the first usually eliminates the rest. Never debug from the last error. With `-file-line-error` (which `compile.sh` uses), the line just above `!` gives `file.tex:42:` — the exact source location.

The `l.NN` after the message shows the line being processed when the error surfaced; with multi-line environments the true cause is often a few lines earlier (an unclosed brace or environment from above).

## Common errors

| Error | Meaning | Fix |
|---|---|---|
| `Undefined control sequence` | command not known at that point | typo (`\Reuire`), missing package, or macro used before `\newcommand` — check the `l.NN` line for which command |
| `File 'X.sty' not found` | package not installed | `tlmgr install <package>` (TeX Live) or install the full collection; see env section below |
| `LaTeX Error: Environment X undefined` | env used without its package | e.g. `algorithmic` needs `\usepackage{algpseudocode}` |
| `Misplaced \noalign` / `Extra alignment tab` | table structure broken | `\midrule` outside tabular; column count exceeds the `&`+1 in the column spec |
| `Runaway argument?` / `File ended while scanning` | a brace or environment left open above | count `{`/`}` and `\begin{}`/`\end{}` pairs from the reported line upward |
| `! Missing $ inserted` | math-only token in text mode (`_`, `^`, `\alpha`) | wrap in `$...$` or `\(...\)`; watch filenames with underscores |
| `! LaTeX Error: Too many }'s` | extra closing brace | usually just above the reported line |
| `Float too large for page` | figure/table wider than the column | reduce `width=` (`0.9\linewidth`), or use `table*`/`figure*` for full-width in two-column layouts |
| `Not in outer par mode` | float inside a list/footnote/minipage | move the float out, or add `[H]` via the `float` package (last resort) |
| `Dimension too large` | a number > 16384pt (≈5.75m) | almost always a typo'd dimension or a broken `\includegraphics` scale |
| `!pdfTeX error ... cannot find image` | figure file missing or bad extension | use PDF/PNG/JPG; check the path (`figures/...`) and exact case-sensitive filename |
| `pdfTeX error (font expansion): auto expansion is only possible with scalable fonts` | acmart template, Libertine fonts not installed | `apt install texlive-fonts-extra` or `tlmgr install libertine libertinust1math` |

## Reference/citation warnings

Warnings don't stop the compile but mark defects for submission:

- `LaTeX Warning: Reference 'fig:x' undefined` — no `\label{fig:x}` exists, or the label is placed after the `\caption` (labels must FOLLOW `\caption` inside floats), or the file defining it isn't `\input`-ed in `main.tex`.
- `Citation 'x' undefined` — see `bibtex-guide.md` (usually needs a full compile or the key is misspelled).
- `There were multiply-defined labels` — two `\label{sec:...}` share a name; every label must be globally unique. `\ref` silently points at the last one.
- `Label(s) may have changed. Rerun.` — one more `pdflatex` pass is needed; `compile.sh full` already does the right number.

## "It should work but doesn't" — clean rebuild

Auxiliary files from a failed run poison the next one (a truncated `.aux` produces phantom errors; a stale `.bbl` pins dead citations). Clean rebuild:

```bash
rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz
scripts/compile.sh <dir> full
```

Make this the first response to any *inexplicable* error state — it resolves a surprising share of them.

## TeX environment problems

If `pdflatex` isn't found at all, run `scripts/check_latex_env.sh` — it detects the OS, checks the toolchain, runs a hello-world compile, and prints install advice. Summary:

- **Debian/Ubuntu**: `sudo apt install texlive-latex-recommended texlive-latex-extra texlive-publishers` (`-publishers` provides IEEEtran/acmart; `texlive-full` if disk is not a concern).
- **macOS**: `brew install --cask basictex`, then `sudo tlmgr update --self && sudo tlmgr install ieeetran acmart algorithmicx booktabs subfig`; or MacTeX for everything.
- **Windows**: TeX Live or MiKTeX installer (MiKTeX auto-installs packages on first use).
- **Common PATH issue** (TeX Live installed but not found): the installer's bin dir (e.g. `/usr/local/texlive/2025/bin/x86_64-linux`) is not on `PATH` — add it to `~/.bashrc`.

Multi-pass builds can also be done with `latexmk -pdf main.tex`, which reruns automatically until stable — install it if compiles are frequent.
