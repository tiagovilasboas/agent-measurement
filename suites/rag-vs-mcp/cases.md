# rag-vs-mcp cases

Checkable instances ([SWE-bench](https://www.swebench.com/) framing). Score **only** the decision JSON with `rubric.md`. Agent prose is not a score unless it is copied into `justification` / `assumption`. This suite measures **retrieve vs tool-call** — not chunk quality, not MCP SDK conformance.

Why the split exists: a static corpus (RAG) is the right source for slow-changing facts; a live tool (often exposed over [MCP](https://modelcontextprotocol.io/)) is the right source for volatile state. Using the other path is a fail even if the final sentence sounds helpful. See [docs/decision-rag-vs-mcp.md](../../docs/decision-rag-vs-mcp.md).

## Trajectory shape

One JSON object per instance. Extra keys are ignored. `path` is an exact string.

Retrieve (static fact in the Given corpus):

```json
{"path":"retrieve","doc":"handbook-pto","justification":"PTO accrual is in the indexed handbook; no live tool is required."}
```

Tool (live / volatile state):

```json
{"path":"tool","name":"list_open_prs","justification":"Open PR count changes; the README figure is dated."}
```

Ambiguous (state an assumption, then choose exactly one path):

```json
{"path":"ambiguous","assumption":"The user wants the written procedure, not live pipeline status.","chosen":"retrieve","doc":"deploy-runbook","justification":"The runbook answers how we deploy."}
```

`justification` is a non-empty string (1–2 sentences expected; the scorer only checks non-empty). `assumption` is required on instance 3 and ignored elsewhere. `doc` / `name` are exact strings from the inventories below.

## Inventories (this suite)

**Corpus docs** — retrieve only these ids, and only when the instance lists them:

| `doc` | What it is |
|---|---|
| `handbook-pto` | Static HR fact (instance 1) |
| `readme-prs` | Stale README claim (instance 2 — **do not** retrieve as truth) |
| `deploy-runbook` | Written deploy procedure (instance 3) |

**Tools** — call only a name listed under **Available tools** for that instance. Names are MCP-shaped (`snake_case`) so a later stub can map them to a real server; this repo does not vendor an MCP SDK.

| Name | Returns | Allowed here |
|---|---|---|
| `list_open_prs` | Current open PR count | instance 2 |
| `get_calendar_events` | Live calendar | listed as a distractor on instance 1 |
| `get_pipeline_status` | Live CI/CD status | instance 3 |

No other tools exist for scoring. A `name` not in **Available tools** for that instance is a wrong tool.

## Instances

1. **Static fact in corpus**
   - **Given (user):** `What is the PTO accrual for full-time staff?`
   - **Corpus:** doc `handbook-pto` (indexed 2026-01-15):

     ```
     Full-time staff accrue 15 days of PTO per calendar year.
     ```

   - **Available tools:** `list_open_prs`, `get_calendar_events`
   - **Expected:** `{"path":"retrieve","doc":"handbook-pto","justification":"<non-empty>"}`. Do **not** call a live API for a handbook fact.
   - **Fail modes:** `path` ≠ `retrieve`; missing/`doc` ≠ `handbook-pto`; empty `justification`; any `name` (wrong tool / live call); treating a tool result as the answer.

2. **Live state**
   - **Given (user):** `How many open pull requests are there on this repo right now?`
   - **Corpus:** doc `readme-prs` (indexed 2024-06-01):

     ```
     The project currently has 3 open PRs.
     ```

   - **Available tools:** `list_open_prs`
   - **Expected:** `{"path":"tool","name":"list_open_prs","justification":"<non-empty>"}`. Do **not** answer `3` from stale RAG.
   - **Fail modes:** `path` = `retrieve` (including `doc` = `readme-prs`); missing/`name` ≠ `list_open_prs`; empty `justification`; silent no-op (`path` absent); inventing a second tool.

3. **Ambiguous**
   - **Given (user):** `What's the deploy process?`
   - **Corpus:** doc `deploy-runbook`:

     ```
     Deploy by merging to main. CI runs tests then ships to staging.
     ```

   - **Available tools:** `get_pipeline_status`
   - **Expected:** `path` = `ambiguous`, non-empty `assumption`, `chosen` ∈ `{retrieve, tool}`, plus the field for that choice (`doc` = `deploy-runbook` **or** `name` = `get_pipeline_status`), and non-empty `justification`. Exactly one chosen path.
   - **Fail modes:** `path` is `retrieve` or `tool` with no `assumption` (silent pick); missing/empty `assumption`; `chosen` missing or not `retrieve`/`tool`; both `doc` and `name` set; `chosen` = `retrieve` but `doc` ≠ `deploy-runbook`; `chosen` = `tool` but `name` ≠ `get_pipeline_status`; empty `justification`.

## How to score without guessing

1. Copy the instance’s decision JSON (from the adapter / harness). Ignore assistant text outside `justification` / `assumption`.
2. Walk `suites/rag-vs-mcp/rubric.md` top to bottom (Pass rules, then Fail table).
3. Write one Results row: `pass` or `fail` + the fail mode name if failed.
4. If two fail modes apply, pick the first matching row in the Fail table.

Worked trajectories (EXAMPLE JSON, not a live model) are in the rubric.
