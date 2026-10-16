#!/bin/bash
# =============================================================
# install.sh — install the latex-paper-writing skill into the
# coding agents you use.
#
# Usage:
#   ./install.sh              auto-detect installed agents
#   ./install.sh --agent X    claude | codex | gemini | all
#   ./install.sh --list       show detection, install nothing
#   ./install.sh --remove     uninstall from every agent
#
# Method: symlink for Claude Code and Gemini CLI (live — edits
# in this repo apply immediately); full copy for Codex (its
# skill discovery does not reliably follow symlinks — re-run
# this script after pulling repo updates, and start a new
# Codex session).
# =============================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SKILL_DIR="$REPO_DIR/latex-paper-writing"
SKILL_NAME="latex-paper-writing"

# agent|config-home|method(link|copy)
AGENTS=(
    "claude|$HOME/.claude|link"
    "codex|$HOME/.codex|copy"
    "gemini|$HOME/.gemini|link"
)

usage() {
    echo "Usage: $0 [--agent claude|codex|gemini|all] [--list] [--remove]"
    exit 1
}

MODE="install"
AGENT_ARG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --agent)  AGENT_ARG="${2:-}"; [[ -z "$AGENT_ARG" ]] && usage; shift 2 ;;
        --list)   MODE="list"; shift ;;
        --remove) MODE="remove"; shift ;;
        -h|--help) usage ;;
        *) echo "Unexpected argument: $1"; usage ;;
    esac
done

[[ -f "$SKILL_DIR/SKILL.md" ]] || { echo "ERROR: $SKILL_DIR/SKILL.md not found"; exit 1; }

known_agent() {
    local a
    for a in "${AGENTS[@]}"; do [[ "${a%%|*}" == "$1" ]] && return 0; done
    return 1
}

if [[ -n "$AGENT_ARG" && "$AGENT_ARG" != "all" ]] && ! known_agent "$AGENT_ARG"; then
    echo "ERROR: unknown agent '$AGENT_ARG' (claude | codex | gemini | all)"
    exit 1
fi

# True if the installed path is this skill: either a symlink
# resolving into this repo, or a copied dir carrying our SKILL.md.
is_ours() {
    local p="$1"
    if [[ -L "$p" && -d "$p" ]]; then
        [[ "$(cd "$p" && pwd -P)" == "$SKILL_DIR" ]]
    elif [[ -d "$p" && -f "$p/SKILL.md" ]]; then
        grep -q "^name: $SKILL_NAME" "$p/SKILL.md"
    else
        return 1
    fi
}

install_one() {
    local name="$1" home_dir="$2" method="$3"
    local dest="$home_dir/skills/$SKILL_NAME"

    if [[ -e "$dest" || -L "$dest" ]]; then
        if ! is_ours "$dest"; then
            echo "  ERROR [$name]: $dest exists and is not this skill — inspect it manually"
            return 1
        fi
        rm -rf "$dest"
    fi

    mkdir -p "$home_dir/skills"
    if [[ "$method" == "copy" ]]; then
        cp -R "$SKILL_DIR" "$dest"
        echo "  ✅ $name: copied to $dest (re-run after repo updates; new Codex sessions only)"
    else
        ln -s "$SKILL_DIR" "$dest"
        echo "  ✅ $name: $dest -> $SKILL_DIR"
    fi
}

remove_one() {
    local name="$1" home_dir="$2"
    local dest="$home_dir/skills/$SKILL_NAME"

    if [[ ! -e "$dest" && ! -L "$dest" ]]; then
        echo "  $name: not installed"
        return 0
    fi
    if ! is_ours "$dest"; then
        echo "  ERROR [$name]: $dest exists but is not this skill — leaving it alone"
        return 1
    fi
    rm -rf "$dest"
    echo "  ✅ $name: removed $dest"
}

RC=0
for entry in "${AGENTS[@]}"; do
    IFS='|' read -r name home_dir method <<< "$entry"

    # In auto mode, only touch agents that look installed.
    if [[ -z "$AGENT_ARG" && "$MODE" == "install" && ! -d "$home_dir" ]]; then
        continue
    fi
    # Explicit agent selection filters the loop.
    if [[ -n "$AGENT_ARG" && "$AGENT_ARG" != "all" && "$name" != "$AGENT_ARG" ]]; then
        continue
    fi

    case "$MODE" in
        list)
            if [[ -d "$home_dir" ]]; then
                echo "  $name: detected ($home_dir)"
            else
                echo "  $name: not found"
            fi
            ;;
        remove)
            remove_one "$name" "$home_dir" || RC=1
            ;;
        install)
            install_one "$name" "$home_dir" "$method" || RC=1
            ;;
    esac
done

[[ "$MODE" == "install" && $RC -eq 0 ]] && echo "Done. Mention writing a paper in any of the installed agents to trigger the skill."
exit $RC
