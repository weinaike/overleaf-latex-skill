#!/bin/bash
# =============================================================
# compile.sh — compile a LaTeX paper with readable error output.
#
# Usage:
#   compile.sh [dir] [quick|full]
#
#   quick (default)  one pdflatex pass — for iterating on content
#   full             pdflatex → bibtex → pdflatex ×2 — required
#                    after adding/changing citations, and for the
#                    final PDF. Also reports unresolved references.
#
# The script extracts real errors (lines starting with "!" and
# file:line: markers) from the .log instead of dumping it all.
# =============================================================
set -uo pipefail

DIR="."
MODE="quick"

for arg in "$@"; do
    case "$arg" in
        quick|full) MODE="$arg" ;;
        -h|--help)  grep '^#' "$0" | head -14; exit 0 ;;
        *)          DIR="$arg" ;;
    esac
done

cd "$DIR" || { echo "ERROR: cannot enter directory: $DIR"; exit 1; }

MAIN="${MAIN:-main.tex}"
[[ -f "$MAIN" ]] || { echo "ERROR: $MAIN not found in $DIR (override with MAIN=<file>)"; exit 1; }
JOB="${MAIN%.tex}"

run_pdflatex() {
    pdflatex -interaction=nonstopmode -file-line-error "$MAIN" > /dev/null 2>&1
    local rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "COMPILE FAILED — errors (first occurrence first):"
        echo "---------------------------------------------------"
        grep -E "^\!|^[^ :][^:]*\.tex:[0-9]+:" "$JOB.log" | head -25
        echo "---------------------------------------------------"
        echo "Full log: $DIR/$JOB.log — read the FIRST error; later ones are usually cascade effects."
        exit 1
    fi
}

report_unresolved() {
    local unresolved
    unresolved=$(grep -E "Warning.*[Cc]itation .* undefined|Warning.*Reference .* undefined|There were undefined references" "$JOB.log" 2>/dev/null | sort -u)
    if [[ -n "$unresolved" ]]; then
        echo ""
        echo "WARNING — unresolved references (run a full compile if you just added them):"
        echo "$unresolved" | head -15
    fi
}

echo "[$MODE compile] $DIR ($MAIN)"

if [[ "$MODE" == "full" ]]; then
    run_pdflatex
    echo "  pass 1/4 done (generates .aux)"
    bibtex "$JOB" > /dev/null 2>&1
    if [[ $? -ne 0 ]] && [[ -s "$JOB.blg" ]]; then
        echo "BIBTEX WARNINGS/ERRORS:"
        grep -iE "error|warning" "$JOB.blg" | head -10
    fi
    echo "  bibtex done"
    run_pdflatex
    echo "  pass 2/4 done (injects bibliography)"
    run_pdflatex
    echo "  pass 3/4 + 4/4 done (resolves cross-references)"
    report_unresolved
else
    run_pdflatex
    report_unresolved
fi

if [[ -f "$JOB.pdf" ]]; then
    PAGES=$(strings "$JOB.pdf" 2>/dev/null | grep -o "/Count [0-9]*" | tail -1 | grep -o "[0-9]*$")
    echo "OK → $DIR/$JOB.pdf${PAGES:+ ($PAGES pages)}"
else
    echo "ERROR: no PDF produced — inspect $DIR/$JOB.log"
    exit 1
fi
