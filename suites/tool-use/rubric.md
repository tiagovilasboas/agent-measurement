# tool-use rubric

**Metric:** pass/fail per instance ([BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html)-style: exact name, required args, withhold when no valid tool).

Scorer role (Inspect): score only against this file — not agent prose ([Inspect tasks](https://inspect.aisi.org.uk/tasks.html): dataset + solver + scorer).

## Pass (all must hold)

1. **Name** — called tool equals Expected (exact string).
2. **Required args** — every required argument listed in the case is present and non-empty.
3. **No extras** — no additional tool calls in the scored turn.
4. **Withhold** — when Expected is ask / fail-closed / no valid tool: **zero** tool calls.

## Fail (any)

| Mode | Check |
|---|---|
| Wrong tool | Name ≠ Expected |
| Hallucinated args | Required value invented when the prompt did not supply it |
| Missing required arg | Required key absent or empty |
| Extra tool | Correct tool plus another call |
| Silent no-op | No call when a tool was required |
| Over-call | Tool called when the right tool is unavailable (should withhold) |

## Does not measure ([HELM](https://crfm.stanford.edu/helm/) incompleteness)

- Latency, cost, token count
- Multi-turn repair after a failed call
- Parallel / multi-function calling
- Correctness of the tool's return value after execution
- Safety / prompt-injection resistance
