# Retrieve vs tool-call (`rag-vs-mcp`)

Tiny decision suite: given a user question, a small corpus, and a small tool list, does the agent **retrieve** a static doc or **call** a live tool?

This is not a RAG quality bench and not an MCP conformance test. It is one named metric (pass/fail per instance) so a peer can score without guessing. Official protocol for live tools/resources: [Model Context Protocol](https://modelcontextprotocol.io/). Harness layout: [Inspect](https://inspect.aisi.org.uk/tasks.html) (dataset + solver + scorer). Instances: [SWE-bench](https://www.swebench.com/) framing. Reports: [HELM](https://crfm.stanford.edu/helm/) — instance rows + incompleteness.

## When to retrieve vs call

| Signal in the prompt | Path | Why |
|---|---|---|
| Fact that lives in a dated/indexed corpus (policy, runbook, ADR) | `retrieve` | The answer does not change between index and question. A live API is the wrong source. |
| Volatile state (“right now”, open PRs, queue depth, pipeline) | `tool` | RAG will happily quote a stale chunk. The tool (MCP-shaped or otherwise) is the measurement plane. |
| Either reading could be reasonable | `ambiguous` | State the assumption, then choose **exactly one** path. Silent pick is a fail. |

MCP is **how** a host exposes tools; RAG is **what** you inject from an index. This suite does not require an MCP SDK in-repo — keep adapters as `adapters/<name>.sh` ([contract](../adapters/README.md)). Do not lock a later stub to one vendor.

## Instances (ids only)

Full Given / Expected / fail modes: [`suites/rag-vs-mcp/cases.md`](../suites/rag-vs-mcp/cases.md). Scorer: [`suites/rag-vs-mcp/rubric.md`](../suites/rag-vs-mcp/rubric.md).

1. **Static fact** — PTO accrual in `handbook-pto` → retrieve. Do not call calendar/PR tools.
2. **Live state** — “open PRs **right now**” vs a 2024 README that says `3` → `list_open_prs`. Stale retrieve is a fail.
3. **Ambiguous** — “deploy process” with both a runbook and `get_pipeline_status` → `path=ambiguous` + assumption + one chosen path.

## Dry-run (no API key)

```bash
./scripts/run.sh rag-vs-mcp
```

Default solver is `adapters/echo.sh`. It emits **no** canned trajectories for this suite (`No script fixtures…`) so a score is not implied. CI runs the same command (see [`.github/workflows/dry-run.yml`](../.github/workflows/dry-run.yml)). Unknown suite → exit 1.

Swap a real stub later (still no keys in this repo):

```bash
ADAPTER=your-stub ./scripts/run.sh rag-vs-mcp
```

`adapters/your-stub.sh` must print one decision JSON per instance (`path` + `doc`/`name`/`assumption` as in `cases.md`). Extra keys ignored.

## EXAMPLE fill (not prod)

After a real (or stub) run, fill Results **per instance**. Numbers below are **EXAMPLE / sample data** — they are not a paid-model score and not first-party prod metrics.

| Case | Result | Notes |
|------|--------|-------|
| 1. Static fact in corpus | **EXAMPLE pass** | `path=retrieve`, `doc=handbook-pto`, non-empty justification |
| 2. Live state | **EXAMPLE fail** / stale retrieve | Answered `3` from `readme-prs` instead of `list_open_prs` |
| 3. Ambiguous | **EXAMPLE pass** | `path=ambiguous`, assumption stated, `chosen=retrieve` + `deploy-runbook` |

**EXAMPLE score:** 2/3 pass (instance-level; not aggregate-only). Do not cite this as a live eval. Worked JSON for each fail mode lives in the rubric.

## Does not measure

Retrieval quality, tool return correctness, MCP SDK/vendor conformance, latency, cost, multi-turn repair, hybrid retrieve-then-tool as a capability. Name those in the report if you fill one ([HELM](https://crfm.stanford.edu/helm/) incompleteness).
