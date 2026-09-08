#!/usr/bin/env bash
# Local fixture runner (Inspect "solver" slot).
# Reads adapters/fixtures/<suite-id>.json and emits the adapter contract.
# Deterministic, no model, no API key. Not a production agent.
#
# Usage: adapters/fixture.sh <suite-id>
# Stdout: markdown trajectories. Env: none required. Needs python3 to parse JSON.
#
# Swap pattern: a later HTTP/API solver would POST the suite id and print the
# same stdout shape. This stub loads canned EXAMPLE JSON from disk instead.

set -euo pipefail

SUITE="${1:-}"
if [[ -z "$SUITE" || "$SUITE" == "-h" || "$SUITE" == "--help" ]]; then
  echo "Usage: adapters/fixture.sh <suite-id>" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
FIXTURE="$ROOT/fixtures/${SUITE}.json"

echo "adapter: fixture"
echo "kind: local fixture runner (not a model; no API key)"
echo "suite: $SUITE"
echo

if [[ ! -f "$FIXTURE" ]]; then
  echo "No script fixtures for \`$SUITE\`. Trajectories omitted — score is not implied."
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "adapters/fixture.sh needs python3 to read $FIXTURE" >&2
  exit 1
fi

python3 - "$FIXTURE" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as fh:
    data = json.load(fh)

instances = data.get("instances")
if not isinstance(instances, list):
    print("fixture JSON must have an instances array", file=sys.stderr)
    sys.exit(1)

print("## Trajectories")
print()
print(
    "_Canned fixture output. EXAMPLE / sample data — not a paid-model score, not prod metrics._"
)
print()

for inst in instances:
    ident = inst.get("id", "?")
    title = inst.get("title", "")
    print(f"### {ident}. {title}".rstrip())
    print()
    if inst.get("prompt"):
        print(f"- **Prompt:** `{inst['prompt']}`")
    if inst.get("tools"):
        print(f"- **Available tools:** `{inst['tools']}`")
    if inst.get("note"):
        print(f"- **Note:** {inst['note']}")
    print()
    print("```json")
    print(json.dumps(inst.get("json", {}), separators=(",", ":")))
    print("```")
    print()
PY
