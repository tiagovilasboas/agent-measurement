# tool-use rubric

**Metric:** pass/fail per instance ([BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html)-style: exact name, required args, withhold when no valid tool).

Scorer role ([Inspect](https://inspect.aisi.org.uk/tasks.html)): score only against this file. Read `calls` from the trajectory JSON in `cases.md`. Do not score fluency, apologies, or “I would call…”.

## Pass (all must hold)

1. **Name** — every called `name` is in the instance’s Available tools; the set of names matches Expected (exact string).
2. **Required args** — every required argument listed for that tool is present, a non-empty string, and equals the Expected value when the instance names one (`city` = `Lisbon` on instances 1–2).
3. **No extras** — `calls.length` equals Expected (1 on instances 1–2; 0 on instances 3–4).
4. **Withhold** — when Expected is `{"calls":[]}`: **zero** tool calls. Prose-only “ask” is allowed; a call is not.

## Fail (any) — first match wins

| Mode | Check |
|---|---|
| Wrong tool | A `name` ≠ Expected, or a `name` not in Available tools |
| Hallucinated args | A required value appears that the **Given** prompt did not supply (instance 3: any `city`) |
| Missing required arg | Required key absent, empty, or (instances 1–2) `city` ≠ `Lisbon` |
| Extra tool | Correct call plus any additional element in `calls` |
| Silent no-op | `calls` empty when Expected is a call (instances 1–2) |
| Over-call | Any call when Expected is withhold / fail-closed (instances 3–4) |

## Worked trajectories (score these)

Same shape as `adapters/echo.sh` output. **EXAMPLE** JSON — not a live model.

**Instance 1 — pass**

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Lisbon"}}]}
```

**Instance 1 — fail / missing required arg** (`city` wrong)

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Porto"}}]}
```

**Instance 2 — fail / extra tool**

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Lisbon"}},{"name":"send_email","arguments":{"to":"ada@example.com","body":"hi"}}]}
```

**Instance 3 — fail / hallucinated args** (this is what `echo` emits)

```json
{"calls":[{"name":"get_weather","arguments":{"city":"London"}}]}
```

**Instance 3 — pass**

```json
{"calls":[]}
```

**Instance 4 — fail / over-call**

```json
{"calls":[{"name":"send_email","arguments":{"to":"ops@example.com","body":"Lisbon weather"}}]}
```

**Instance 4 — pass**

```json
{"calls":[]}
```

## Does not measure ([HELM](https://crfm.stanford.edu/helm/) incompleteness)

- Latency, cost, token count
- Multi-turn repair after a failed call (one trajectory only)
- Parallel / multi-function calling as a capability (an extra call is just **fail / extra tool**)
- Correctness of the tool’s return value after execution
- Safety / prompt-injection resistance
- Whether `echo` (or any stub) matches a paid model
