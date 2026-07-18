#!/usr/bin/env zsh
# Ver 2026-07-19 03:15, by Claude Sonnet 5
# render-card.sh — merge a dev-env-audit JSON summary into a self-contained
# HTML report card. Pure zsh + sed + awk. No Python, no network, no external
# dependency beyond coreutils that ship with macOS.
#
# The three templates (render-card.terminal.html / .paper.html / .brutalist.html)
# are static files with exactly one placeholder line: %%AUDIT_JSON_DATA%%
# Everything else in them is fixed HTML/CSS/JS that never changes per run —
# this script's only job is a mechanical text substitution, not generation.
#
# Usage:
#   zsh render-card.sh <input.json> <output.html> [template]
#
# <template> is one of: terminal | paper | brutalist (case-insensitive).
# Omit it to let the script pick one at random (uniform, via $RANDOM) —
# this skill never stops to ask the user which look they want.

# Portable guard (plain POSIX syntax, parses fine under bash/sh too): if this
# ever gets run with the wrong interpreter, fail with one clear line instead
# of a cascade of zsh-syntax parse errors further down. Unlike the audit
# scripts, this one has no macOS-specific logic (just sed/awk text merging),
# so there's no OS check here — it's fine on Linux too, as long as it's zsh.
if [ -z "$ZSH_VERSION" ]; then
  echo "error: this script requires zsh — run: zsh scripts/render-card.sh" >&2
  exit 1
fi

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
TEMPLATES=(terminal paper brutalist)

usage() {
  echo "usage: zsh render-card.sh <input.json> <output.html> [${(j:|:)TEMPLATES}]" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage

INPUT_JSON="$1"
OUTPUT_HTML="$2"
TEMPLATE_NAME="${3:-}"

if [[ ! -f "$INPUT_JSON" ]]; then
  echo "error: input JSON not found: $INPUT_JSON" >&2
  exit 2
fi

if [[ -z "$TEMPLATE_NAME" ]]; then
  TEMPLATE_NAME="${TEMPLATES[$((RANDOM % ${#TEMPLATES[@]} + 1))]}"
else
  TEMPLATE_NAME="${TEMPLATE_NAME:l}"
  if [[ ! " ${TEMPLATES[*]} " == *" $TEMPLATE_NAME "* ]]; then
    echo "error: unknown template '$TEMPLATE_NAME' (expected one of: ${TEMPLATES[*]})" >&2
    exit 2
  fi
fi

TEMPLATE_FILE="$SCRIPT_DIR/render-card.${TEMPLATE_NAME}.html"
if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "error: template file missing: $TEMPLATE_FILE" >&2
  exit 2
fi

ESCAPED_JSON="$(mktemp)"
trap 'rm -f "$ESCAPED_JSON"' EXIT

# The only mechanical rule that matters: escape "</" to "<\/" so a JSON
# string value that happens to contain "</script>" can't prematurely close
# the <script type="application/json"> block it's embedded in. Valid JSON
# allows an escaped solidus (\/ is identical to / once parsed), so this
# never changes the data — it only protects the HTML parser.
sed 's#</#<\\/#g' "$INPUT_JSON" > "$ESCAPED_JSON"

awk -v datafile="$ESCAPED_JSON" '
  /%%AUDIT_JSON_DATA%%/ { while ((getline line < datafile) > 0) print line; next }
  { print }
' "$TEMPLATE_FILE" > "$OUTPUT_HTML"

if grep -q '%%AUDIT_JSON_DATA%%' "$OUTPUT_HTML"; then
  echo "error: placeholder was not replaced — template may be malformed: $TEMPLATE_FILE" >&2
  exit 1
fi

echo "wrote $OUTPUT_HTML (template: $TEMPLATE_NAME)" >&2
