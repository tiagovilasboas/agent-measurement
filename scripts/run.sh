#!/usr/bin/env bash
# Agent Measurement — minimal runner (no model required for dry-run)
set -euo pipefail
SUITE="${1:-tool-use}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATE="$(date -u +%Y-%m-%d)"
OUT="$ROOT/reports/${SUITE}-${DATE}.md"
CASES="$ROOT/suites/${SUITE}/cases.md"
RUBRIC="$ROOT/suites/${SUITE}/rubric.md"

if [[ ! -f "$CASES" ]]; then
  echo "Unknown suite: $SUITE (missing $CASES)" >&2
  exit 1
fi

mkdir -p "$ROOT/reports"
{
  echo "# Report: $SUITE ($DATE UTC)"
  echo
  echo "## Rubric"
  echo
  cat "$RUBRIC"
  echo
  echo "## Cases"
  echo
  cat "$CASES"
  echo
  echo "## Results"
  echo
  echo "| Case | Result | Notes |"
  echo "|------|--------|-------|"
  echo "| (fill after agent run) | pass/fail | |"
  echo
  echo "_Dry-run scaffold — replace Results after executing with your agent/harness._"
} > "$OUT"

echo "Wrote $OUT"
