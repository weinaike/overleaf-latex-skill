#!/bin/bash
# =============================================================
# new_paper.sh — scaffold a new LaTeX paper project.
#
# Usage:
#   new_paper.sh <venue> <target-dir> [--title "Paper Title"]
#
# Venues: ieee-conference, ieee-journal, acm-sigconf, arxiv,
#         aas-journal
#
# Copies the venue's main.tex + abstract.tex, section skeletons
# into chapters/, the sample references.bib, and an empty
# figures/ directory. A venue may bundle its own chapters/
# and references.bib (aas-journal does — astronomy papers are
# structured differently) and support files such as class files
# (aas-journal ships aastex701.cls + aasjournalv7.bst because
# AASTeS is not part of TeX Live).
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets"

VENUES="ieee-conference ieee-journal acm-sigconf arxiv aas-journal"

usage() {
    echo "Usage: $0 <venue> <target-dir> [--title \"Paper Title\"]"
    echo "Venues: $VENUES"
    exit 1
}

VENUE=""
TARGET=""
TITLE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --title) TITLE="$2"; shift 2 ;;
        -h|--help) usage ;;
        *)
            if [[ -z "$VENUE" ]]; then VENUE="$1"
            elif [[ -z "$TARGET" ]]; then TARGET="$1"
            else echo "Unexpected argument: $1"; usage
            fi
            shift ;;
    esac
done

[[ -z "$VENUE" || -z "$TARGET" ]] && usage

if ! echo "$VENUES" | grep -qw "$VENUE"; then
    echo "ERROR: unknown venue '$VENUE'"
    echo "Available venues: $VENUES"
    exit 1
fi

if [[ -e "$TARGET" ]] && [[ -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
    echo "ERROR: target directory '$TARGET' exists and is not empty"
    exit 1
fi

mkdir -p "$TARGET/chapters" "$TARGET/figures"

cp "$ASSETS_DIR/$VENUE/main.tex" "$TARGET/"
cp "$ASSETS_DIR/$VENUE/abstract.tex" "$TARGET/chapters/"

# Section skeletons: venue-specific chapters/ override the shared set
if [[ -d "$ASSETS_DIR/$VENUE/chapters" ]]; then
    cp "$ASSETS_DIR/$VENUE/chapters/"*.tex "$TARGET/chapters/"
else
    cp "$ASSETS_DIR/chapters-shared/"*.tex "$TARGET/chapters/"
fi

# Bibliography: venue-specific if present, else the shared sample
if [[ -f "$ASSETS_DIR/$VENUE/references.bib" ]]; then
    cp "$ASSETS_DIR/$VENUE/references.bib" "$TARGET/"
else
    cp "$ASSETS_DIR/references.bib" "$TARGET/"
fi

# Remaining venue files (class/style files etc.) ship in the project
# root so the scaffold is self-contained
for f in "$ASSETS_DIR/$VENUE"/*; do
    base="$(basename "$f")"
    [[ "$base" == "main.tex" || "$base" == "abstract.tex" || "$base" == "references.bib" ]] && continue
    [[ -f "$f" ]] && cp "$f" "$TARGET/"
done

# Substitute the title if given. The title is LaTeX-escaped
# (& % $ # _ { } \) so common characters like "R&D" don't break
# the compile. For math in a title, edit main.tex by hand.
if [[ -n "$TITLE" ]]; then
    python3 - "$TARGET/main.tex" "$TITLE" <<'PYEOF'
import re, sys

path, title = sys.argv[1], sys.argv[2]
# Single pass so inserted backslashes are never re-escaped
escaped = re.sub(
    r'[\\&%$#_{}]',
    lambda m: {'\\': r'\textbackslash{}', '&': r'\&', '%': r'\%',
               '$': r'\$', '#': r'\#', '_': r'\_',
               '{': r'\{', '}': r'\}'}[m.group()],
    title,
)
src = open(path).read()
open(path, 'w').write(src.replace('Your Paper Title Here', escaped))
PYEOF
fi

echo "Scaffolded $VENUE paper in: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Edit $TARGET/main.tex — fill in title (if not set) and authors"
echo "  2. Write sections in $TARGET/chapters/ (each file has a writing guide in comments)"
echo "  3. Add real entries to $TARGET/references.bib"
echo "  4. Verify the baseline compiles:  compile.sh $TARGET"
