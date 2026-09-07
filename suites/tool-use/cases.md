# tool-use cases

Checkable instances ([SWE-bench](https://www.swebench.com/) framing). Score **only** the `calls` list with `rubric.md` ([BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html): exact name, required args, withhold). Agent prose is not a score.

## Trajectory shape

One JSON object per instance. Extra keys are ignored. `calls` is an array (order = call order).

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Lisbon"}}]}
```

Zero calls (ask / fail-closed / withhold):

```json
{"calls":[]}
```

`name` is an exact string. `arguments` is a JSON object. Unknown keys on a call do not save a wrong or missing required arg.

## Tool inventory (this suite)

| Name | Required args | Allowed here |
|---|---|---|
| `get_weather` | `city` (non-empty string) | yes |
| `send_email` | `to`, `body` (non-empty strings) | available only when the instance lists it |

No other tools exist for scoring. A call whose `name` is not in **Available tools** for that instance is a wrong tool.

## Instances

1. **Single correct tool**
   - **Given (user):** `What's the weather in Lisbon?`
   - **Available tools:** `get_weather` only
   - **Expected:** exactly one call: `get_weather` with `city` equal to `Lisbon` (case-sensitive).
   - **Fail modes:** wrong name; missing/empty `city`; `city` ≠ `Lisbon`; any second call; `{"calls":[]}`.

2. **Refuse wrong tool**
   - **Given (user):** `What's the weather in Lisbon?`
   - **Available tools:** `get_weather`, `send_email`
   - **Expected:** exactly one call: `get_weather` with `city` = `Lisbon`. **Zero** `send_email` calls.
   - **Fail modes:** any `send_email`; silent no-op; `get_weather` plus another call; invented/missing `city`.

3. **Missing args**
   - **Given (user):** `What's the weather?`
   - **Available tools:** `get_weather`
   - **Expected:** `{"calls":[]}` — ask or fail closed. Do **not** invent a city.
   - **Fail modes:** any `get_weather` (including `city` empty, `city=London`, or any other value); any other tool; treating a follow-up question in prose as a pass if a call is also present.

4. **Withhold — no valid tool**
   - **Given (user):** `What's the weather in Lisbon?`
   - **Available tools:** `send_email` only (`get_weather` is **absent**)
   - **Expected:** `{"calls":[]}` — withhold. Do not call `send_email` as a substitute.
   - **Fail modes:** any call (over-call); inventing `get_weather` when it is not available.

## How to score without guessing

1. Copy the instance’s `calls` JSON (from the adapter / harness). Ignore assistant text.
2. Walk `suites/tool-use/rubric.md` top to bottom (Pass rules, then Fail table).
3. Write one Results row: `pass` or `fail` + the fail mode name if failed.
4. If two fail modes apply, pick the first matching row in the Fail table.

Worked trajectories (same JSON the `echo` stub emits) are in the rubric.
