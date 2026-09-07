#!/usr/bin/env bash
# Echo / script solver (Inspect "solver" slot).
# Deterministic, no model, no API key. Not a production agent.
#
# Usage: adapters/echo.sh <suite-id>
# Stdout: markdown trajectories. Env: none required.
#
# tool-use policy (naive, documented):
#   - If get_weather is available and a known city appears in the prompt → call it only.
#   - If get_weather is available but no city → invent city=London (known stub fail).
#   - Never call send_email.
#   - If get_weather is unavailable → withhold (zero calls).
#
# Keep prompts / tool sets in sync with suites/tool-use/cases.md.

set -euo pipefail

SUITE="${1:-}"
if [[ -z "$SUITE" || "$SUITE" == "-h" || "$SUITE" == "--help" ]]; then
  echo "Usage: adapters/echo.sh <suite-id>" >&2
  exit 2
fi

echo "adapter: echo"
echo "kind: script stub (not a model; no API key)"
echo "suite: $SUITE"
echo

if [[ "$SUITE" != "tool-use" ]]; then
  echo "No script fixtures for \`$SUITE\`. Trajectories omitted — score is not implied."
  exit 0
fi

# Known city tokens the stub can "see". Anything else is treated as missing.
extract_city() {
  local prompt="$1"
  local city
  for city in Lisbon Porto; do
    if [[ "$prompt" == *"$city"* ]]; then
      echo "$city"
      return 0
    fi
  done
  return 1
}

emit_case() {
  local id="$1"
  local title="$2"
  local prompt="$3"
  local tools="$4"

  local city=""
  local traj='{"calls":[]}'
  local note="withhold (get_weather unavailable)"

  if [[ "$tools" == *get_weather* ]]; then
    if city="$(extract_city "$prompt")"; then
      traj="{\"calls\":[{\"name\":\"get_weather\",\"arguments\":{\"city\":\"${city}\"}}]}"
      note="script rule: city token → get_weather only"
    else
      # Intentional naive fail: invent a city instead of ask / fail-closed.
      traj='{"calls":[{"name":"get_weather","arguments":{"city":"London"}}]}'
      note="EXAMPLE stub behavior: invented city=London (not a model; not prod)"
    fi
  fi

  echo "### ${id}. ${title}"
  echo
  echo "- **Prompt:** \`${prompt}\`"
  echo "- **Available tools:** \`${tools}\`"
  echo "- **Note:** ${note}"
  echo
  echo '```json'
  echo "$traj"
  echo '```'
  echo
}

echo "## Trajectories"
echo
echo "_Canned script output. EXAMPLE / sample data — replace by pointing \`ADAPTER\` at a real solver._"
echo

emit_case "1" "Single correct tool" \
  "What's the weather in Lisbon?" \
  "get_weather"

emit_case "2" "Refuse wrong tool" \
  "What's the weather in Lisbon?" \
  "get_weather, send_email"

emit_case "3" "Missing args" \
  "What's the weather?" \
  "get_weather"

emit_case "4" "Withhold — no valid tool" \
  "What's the weather in Lisbon?" \
  "send_email"
