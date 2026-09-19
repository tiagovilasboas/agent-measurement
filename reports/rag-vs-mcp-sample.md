# Report: rag-vs-mcp (sample)

> **EXAMPLE / SAMPLE DATA. Not a production run.**
> Numbers below come from `ADAPTER=fixture ./scripts/run.sh rag-vs-mcp` (local JSON, no API key).
> They are **not** live prod metrics, not a paid-model score, and not a benchmark claim.

| Field | Value |
|---|---|
| **Date** | EXAMPLE. Replace with the UTC date of *your* run |
| **Model** | `fixture` stub (not a model). Replace with model id after a real run |
| **Adapter** | `adapters/fixture.sh` |
| **Harness** | `scripts/run.sh` + manual score against `suites/rag-vs-mcp/rubric.md` |
| **Metric** | pass/fail per instance (retrieve vs tool vs ambiguous) |
| **EXAMPLE score** | **3/3 pass** (instance-level; canned fixture, not aggregate-only) |

Layout mirrors [Inspect](https://inspect.aisi.org.uk/) (dataset + solver + scorer; walked in the [tutorial](https://inspect.aisi.org.uk/tutorial.html)). Instances are checkable like [SWE-bench](https://github.com/SWE-bench/SWE-bench). Headline % alone is not a report ([HELM](https://crfm.stanford.edu/helm/)). This file is the Staff-dense fill for the decision suite — not a sibling-kit hub.

## Decision

The scored object is **source of truth**, not answer quality. A static corpus (RAG) is correct for slow facts (policy, handbook, runbook). A live tool (MCP-shaped or otherwise) is correct for volatile state (“right now”, open PRs, pipeline). When either reading could be reasonable, the agent must say so (`path=ambiguous`), state the assumption, and choose **exactly one** path.

Using the other path is a fail even if the final sentence is fluent. Prose is not a score. Score only the decision JSON in `suites/rag-vs-mcp/cases.md` against `suites/rag-vs-mcp/rubric.md`.

## Runnable test

```bash
ADAPTER=fixture ./scripts/run.sh rag-vs-mcp
./scripts/check-contract.sh
```

1. Keep the solver keyless (`echo` emits no trajectories here; `fixture` prints EXAMPLE JSON).
2. Open `reports/rag-vs-mcp-<YYYY-MM-DD>.md`.
3. Score **each** `{path, doc|name, …}` block with the rubric (first-match fail table).
4. Fill one Results row per instance. A headline 3/3 without those rows is not a report.

CI fails if `cases.md`, `rubric.md`, `adapters/fixtures/rag-vs-mcp.json`, or this sample file is missing. Expected FAIL commands (exit 1) are in the README.

## Limit

This suite does **not** measure retrieval quality, tool-return correctness, MCP SDK/vendor conformance, hybrid retrieve-then-tool as a capability, latency, cost, or multi-turn repair. Default `echo` is not a model. Canned fixture rows are not a bake-off. Official refs (Inspect, SWE-bench, BFCL) are **shape**, not dependencies — CI does not install them.

## Blast radius

| Miss | What a host would do | Why it matters |
|---|---|---|
| Instance 2 / stale retrieve | Report “3 open PRs” from a 2024 README | Ops-facing number. Merge pressure, “we’re current”, skipped live check. |
| Instance 1 / live tool for a handbook fact | Call calendar or PR tools for PTO accrual | Looks busy; still cannot answer. Wrong measurement plane. |
| Instance 3 / silent pick | Choose retrieve *or* tool with no assumption | Looks decisive. The scored honesty is the assumption. |

Stale retrieve is not “cited the wrong chunk”. It is treating an index as *now*. That is why the fail table lists it first.

## Judgment

- First-match wins. Do not average fail modes or award partial credit for a dated chunk that happens to mention PRs.
- Instance 3: a well-chosen path **without** `path=ambiguous` + non-empty `assumption` is still **fail / silent pick**. Confidence is not a substitute for the assumption.
- `justification` is scored as non-empty only. Do not grade style.
- Do not treat this 3/3 EXAMPLE as evidence a paid model would pass. The fixture is the pass-shape so the contract is checkable; the teaching fail lives below.

Worked fail JSON is in the rubric. Decision write-up: [docs/decision-rag-vs-mcp.md](../docs/decision-rag-vs-mcp.md).

## How to replace this file with a real run

1. `ADAPTER=fixture ./scripts/run.sh rag-vs-mcp` (no key). Default `echo` emits no trajectories for this suite.
2. Open the dated file `reports/rag-vs-mcp-<YYYY-MM-DD>.md`.
3. Score each decision object with `suites/rag-vs-mcp/rubric.md`.
4. Replace the Results table and the header fields above. Delete the word EXAMPLE. Do not copy these 3/3 numbers into a “live” report.

## Rubric (short)

See `suites/rag-vs-mcp/rubric.md` at fill time:

- **pass:** exact `path`; matching `doc` / `name` / `chosen`; non-empty `justification`; instance 3 has a non-empty `assumption` and exactly one chosen path.
- **fail:** stale retrieve, silent pick, wrong path/tool/doc, both paths, empty justification, silent no-op (first match wins).
- **Does not measure:** RAG quality, tool return correctness, MCP conformance, hybrid retrieve-then-tool, latency, cost, stub-vs-model match.

## Cases

1. **Static fact in corpus** — PTO accrual in `handbook-pto` → retrieve. Do not call calendar/PR tools.
2. **Live state** — “open PRs **right now**” vs a 2024 README that says `3` → `list_open_prs`. Stale retrieve is a fail.
3. **Ambiguous** — “deploy process” with both a runbook and `get_pipeline_status` → `path=ambiguous` + assumption + one chosen path.

## EXAMPLE trajectories (`fixture` stub)

### 1. Static fact in corpus

```json
{"path":"retrieve","doc":"handbook-pto","justification":"Accrual is a static handbook fact; live PR/calendar tools cannot answer it."}
```

### 2. Live state

```json
{"path":"tool","name":"list_open_prs","justification":"\"Right now\" needs a live count; the README claim is from 2024."}
```

### 3. Ambiguous

```json
{"path":"ambiguous","assumption":"The user wants the written procedure, not whether prod is green.","chosen":"retrieve","doc":"deploy-runbook","justification":"The runbook describes how we deploy."}
```

## Results

| Case | Result | Notes |
|------|--------|-------|
| 1. Static fact in corpus | **EXAMPLE pass** | `path=retrieve`, `doc=handbook-pto`, non-empty justification |
| 2. Live state | **EXAMPLE pass** | `path=tool`, `name=list_open_prs`; did not treat `readme-prs` as truth |
| 3. Ambiguous | **EXAMPLE pass** | `path=ambiguous`, assumption stated, `chosen=retrieve` + `deploy-runbook` |

**EXAMPLE score:** 3/3 pass (instance-level; not aggregate-only). Do not cite this as a live eval.

## Expected FAIL (worked; not this fixture)

The fixture above is the pass-shape so CI can check JSON. The production-shaped miss is instance 2 answered from the dated README. First-match mode: **stale retrieve**.

```json
{"path":"retrieve","doc":"readme-prs","justification":"The README says 3 open PRs."}
```

| Case | Result | Notes |
|------|--------|-------|
| 2. Live state | **EXAMPLE fail** / stale retrieve | Answered `3` from `readme-prs` instead of `list_open_prs` |

That row is the teaching fail: blast radius is an ops-facing number, not a bad citation. Default `echo` invents `city=London` on `tool-use` instance 3 the same way — a documented stub miss, not a model score.

## Incompleteness (HELM)

This sample does **not** claim retrieval quality, tool-return correctness, MCP SDK conformance, hybrid retrieve-then-tool skill, latency, cost, or any production traffic. It only measures the named retrieve-vs-tool metric above. Canned fixture rows are not a trained-model result.

_Illustrative fixture fill. After a real agent run, replace model/harness/date and re-score every row against `rubric.md`._
