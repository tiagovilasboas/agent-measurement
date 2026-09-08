# rag-vs-mcp rubric

**Metric:** pass/fail per instance — the agent picks **retrieve** (static corpus) vs **tool** (live MCP-shaped call) vs **ambiguous** (assumption + exactly one path).

Scorer role ([Inspect](https://inspect.aisi.org.uk/tasks.html)): score only against this file. Read `path` (and `doc` / `name` / `assumption` / `chosen` / `justification`) from the trajectory JSON in `cases.md`. Do not score fluency, RAG citations in prose, or “I would look that up…”.

## Pass (all must hold)

1. **Path** — `path` equals Expected (`retrieve` on 1, `tool` on 2, `ambiguous` on 3). Exact string.
2. **Target** — instance 1: `doc` = `handbook-pto`. Instance 2: `name` = `list_open_prs`. Instance 3: `chosen` ∈ `{retrieve, tool}` and the matching target (`doc` = `deploy-runbook` **or** `name` = `get_pipeline_status`).
3. **Justification** — `justification` is a non-empty string (trim; 1–2 sentences expected, not scored for style).
4. **Assumption (instance 3)** — `assumption` is a non-empty string. Instances 1–2 must **not** use `path` = `ambiguous`.
5. **One path** — no extra live call on retrieve; no retrieve-as-truth on live state. Instance 3: do not set both `doc` and `name`.

## Fail (any) — first match wins

| Mode | Check |
|---|---|
| Stale retrieve | Instance 2: `path` = `retrieve` or `doc` = `readme-prs` (answered from the dated README) |
| Silent pick | Instance 3: `path` is `retrieve` or `tool`, or `assumption` is missing/empty |
| Wrong path | `path` ≠ Expected (`retrieve` / `tool` / `ambiguous` for instances 1 / 2 / 3) |
| Wrong tool | A `name` ≠ Expected, or a `name` not in Available tools |
| Wrong doc | Instance 1: `doc` ≠ `handbook-pto`. Instance 3 with `chosen` = `retrieve`: `doc` ≠ `deploy-runbook` |
| Both paths | Instance 3: both `doc` and `name` are set |
| Empty justification | `justification` missing or whitespace-only |
| Silent no-op | `path` missing/empty when Expected is a decision |

## Worked trajectories (score these)

**EXAMPLE** JSON — not a live model, not prod metrics.

**Instance 1 — pass**

```json
{"path":"retrieve","doc":"handbook-pto","justification":"Accrual is a static handbook fact; live PR/calendar tools cannot answer it."}
```

**Instance 1 — fail / wrong path** (called a live tool)

```json
{"path":"tool","name":"get_calendar_events","justification":"PTO might be on the calendar."}
```

**Instance 1 — fail / empty justification**

```json
{"path":"retrieve","doc":"handbook-pto","justification":""}
```

**Instance 2 — pass**

```json
{"path":"tool","name":"list_open_prs","justification":"\"Right now\" needs a live count; the README claim is from 2024."}
```

**Instance 2 — fail / stale retrieve**

```json
{"path":"retrieve","doc":"readme-prs","justification":"The README says 3 open PRs."}
```

**Instance 3 — pass** (chose retrieve after stating the assumption)

```json
{"path":"ambiguous","assumption":"The user wants the written procedure, not whether prod is green.","chosen":"retrieve","doc":"deploy-runbook","justification":"The runbook describes how we deploy."}
```

**Instance 3 — pass** (chose tool after stating the assumption)

```json
{"path":"ambiguous","assumption":"\"Process\" here means the live pipeline, not the runbook.","chosen":"tool","name":"get_pipeline_status","justification":"Pipeline status is the current deploy process."}
```

**Instance 3 — fail / silent pick** (no assumption)

```json
{"path":"retrieve","doc":"deploy-runbook","justification":"The runbook has the deploy steps."}
```

## Does not measure ([HELM](https://crfm.stanford.edu/helm/) incompleteness)

- Retrieval quality (recall, precision, chunk rank, embeddings)
- Correctness of the tool’s return value after execution
- MCP protocol / SDK / vendor conformance (names are fixtures, not a live server)
- Latency, cost, token count
- Multi-turn repair after a wrong path (one trajectory only)
- Hybrid “retrieve then tool” as a scored capability (instance 3: exactly one chosen path)
- Whether `echo` (or any stub) matches a paid model
