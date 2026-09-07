#!/usr/bin/env bash
# Agent Measurement — dry-run harness (no paid API key by default)
# Dataset: suites/<id>/cases.md · Solver: adapters/${ADAPTER:-echo}.sh · Scorer: rubric.md
set -euo pipefail

SUITE="${1:-tool-use}"
ADAPTER="${ADAPTER:-echo}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATE="$(date -u +%Y-%m-%d)"
OUT="$ROOT/reports/${SUITE}-${DATE}.md"
CASES="$ROOT/suites/${SUITE}/cases.md"
RUBRIC="$ROOT/suites/${SUITE}/rubric.md"
ADAPTER_BIN="$ROOT/adapters/${ADAPTER}.sh"

if [[ ! -f "$CASES" ]]; then
  echo "Unknown suite: $SUITE (missing $CASES)" >&2
  exit 1
fi

if [[ ! -x "$ADAPTER_BIN" ]]; then
  echo "Unknown adapter: $ADAPTER (missing executable $ADAPTER_BIN)" >&2
  exit 1
fi

TRAJ="$("$ADAPTER_BIN" "$SUITE")"

mkdir -p "$ROOT/reports"
{
  echo "# Report: $SUITE ($DATE UTC)"
  echo
  echo "| Field | Value |"
  echo "|---|---|"
  echo "| **Adapter** | \`$ADAPTER\` (script path; default \`echo\` needs no API key) |"
  echo "| **Harness** | \`scripts/run.sh\` |"
  echo "| **Metric** | pass/fail per instance — fill Results against \`rubric.md\` |"
  echo
  echo "## Rubric"
  echo
  cat "$RUBRIC"
  echo
  echo "## Cases"
  echo
  cat "$CASES"
  echo
  echo "## Adapter output"
  echo
  echo "$TRAJ"
  echo
  echo "## Results"
  echo
  echo "| Case | Result | Notes |"
  echo "|------|--------|-------|"
  echo "| (score each trajectory against the rubric) | pass/fail | |"
  echo
  echo "_Dry-run path: cases → \`$ADAPTER\` adapter → this file. Not a paid-model run. Worked EXAMPLE: [reports/tool-use-live.example.md](tool-use-live.example.md)._"
} > "$OUT"

echo "Wrote $OUT"
