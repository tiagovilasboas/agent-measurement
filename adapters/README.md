# Adapters

Inspect [solver](https://inspect.aisi.org.uk/solvers.html) slot in this harness: given a suite id, emit per-instance trajectories. The [scorer](https://inspect.aisi.org.uk/scorers.html) stays in `suites/<id>/rubric.md`. This repo measures that contract — it is not a HITL review queue.

## Contract

```
adapters/<name>.sh <suite-id>
```

| | Rule |
|---|---|
| **argv** | Exactly one positional: the suite id (`tool-use`, `rag-vs-mcp`, `appsec-prompt`). |
| **stdin** | Unused. Do not read the user prompt from stdin. |
| **stdout** | Markdown only. Start with `adapter:`, `kind:`, `suite:` lines. Then either `## Trajectories` + one fenced JSON object per instance, or a single “no fixtures” line. |
| **JSON** | Shape is suite-owned. `tool-use`: `{"calls":[...]}` — see `suites/tool-use/cases.md`. `appsec-prompt`: `{"findings":[...]}` — see `suites/appsec-prompt/cases.md`. Extra keys ignored. |
| **stderr** | Usage / errors only. The runner captures **stdout** into the report, not stderr. |
| **exit** | `0` if the suite id was accepted (including “no fixtures”). Non-zero if the id is missing (`echo` uses `2` for `-h` / empty argv). |
| **env** | None required. Do not read API keys. `scripts/run.sh` sets `ADAPTER`; the script itself must not require secrets. |
| **default** | `echo` — script stub, **no API key**, not a model. |

`scripts/run.sh` invokes `$ROOT/adapters/${ADAPTER:-echo}.sh "$SUITE"`. Swap later with `ADAPTER=your-stub ./scripts/run.sh <suite-id>` once `adapters/your-stub.sh` exists and is executable. Unknown adapter path → runner exit 1. Do not put API keys in this repo.

Canned stub output is **EXAMPLE** data — not a paid-model score, not prod metrics.

## `echo`

| Suite | What stdout contains |
|---|---|
| `tool-use` | Four city-token trajectories (`{"calls":[...]}`). Instance 3 invents `city=London` (documented EXAMPLE fail). |
| any other | `No script fixtures for \`<id>\`. Trajectories omitted — score is not implied.` then exit 0. |

Policy and prompts live in `echo.sh` — keep them aligned with `suites/tool-use/cases.md`. Adding fixtures for `appsec-prompt` / `rag-vs-mcp` is out of this stub’s job.

## Add a stub

1. Create `adapters/<name>.sh` (executable). Same argv / stdout / exit table as above.
2. Emit JSON that matches the suite’s `cases.md` trajectory shape.
3. Label canned rows EXAMPLE. Do not claim prod metrics.
4. Dry-run: `ADAPTER=<name> ./scripts/run.sh <suite-id>`.
