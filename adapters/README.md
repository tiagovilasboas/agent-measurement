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
| **JSON** | Shape is suite-owned. Extra keys ignored. `tool-use`: `{"calls":[...]}`. `appsec-prompt`: `{"findings":[...]}`. `rag-vs-mcp`: `{"path":"retrieve"|"tool"|"ambiguous",...}` — see each suite’s `cases.md`. |
| **stderr** | Usage / errors only. The runner captures **stdout** into the report, not stderr. |
| **exit** | `0` if the suite id was accepted (including “no fixtures”). Non-zero if the id is missing (`echo` uses `2` for `-h` / empty argv). |
| **env** | None required. Do not read API keys. `scripts/run.sh` sets `ADAPTER`; the script itself must not require secrets. |
| **default** | `echo` — script stub, **no API key**, not a model. |

`scripts/run.sh` invokes `$ROOT/adapters/${ADAPTER:-echo}.sh "$SUITE"`. Swap later with `ADAPTER=your-stub ./scripts/run.sh <suite-id>` once `adapters/your-stub.sh` exists and is executable. Unknown adapter path → runner exit 1. Do not put API keys in this repo. A later `rag-vs-mcp` stub may call a real retriever or MCP server **outside** this repo — stdout must still be the suite JSON. Do not vendor an MCP SDK, RAG host, or model client here.

Canned stub output is **EXAMPLE** data — not a paid-model score, not prod metrics.

## `echo`

| Suite | What stdout contains |
|---|---|
| `tool-use` | Four city-token trajectories (`{"calls":[...]}`). Instance 3 invents `city=London` (documented EXAMPLE fail). |
| `rag-vs-mcp` | No fixtures. Decision JSON (`path` / `doc` / `name`) is documented in `suites/rag-vs-mcp/cases.md` for a later stub — score is not implied. |
| any other | `No script fixtures for \`<id>\`. Trajectories omitted — score is not implied.` then exit 0. |

Policy and prompts live in `echo.sh` — keep them aligned with `suites/tool-use/cases.md`. Adding fixtures for `appsec-prompt` / `rag-vs-mcp` is out of this stub’s job. Swap later with `ADAPTER=your-stub`; do not vendor an MCP SDK or RAG host in this repo.

## Add a stub

1. Create `adapters/<name>.sh` (executable). Same argv / stdout / exit table as above.
2. Emit JSON that matches the suite’s `cases.md` trajectory shape (`rag-vs-mcp`: one `{path, doc|name, justification}` object per instance — not a vendor MCP client).
3. Label canned rows EXAMPLE. Do not claim prod metrics.
4. Dry-run: `ADAPTER=<name> ./scripts/run.sh <suite-id>`.
