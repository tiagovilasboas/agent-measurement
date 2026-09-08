# Report: tool-use (EXAMPLE live fill)

> **EXAMPLE / SAMPLE DATA — not a production run.**
> Numbers below come from `./scripts/run.sh tool-use` with the in-repo `echo` script stub (`ADAPTER=echo`).
> They are **not** live prod metrics, not a paid-model score, and not a benchmark claim.

| Field | Value |
|---|---|
| **Date** | EXAMPLE — replace with the UTC date of *your* run |
| **Model** | `echo` script stub (not a model) — replace with model id after a real run |
| **Adapter** | `adapters/echo.sh` |
| **Harness** | `scripts/run.sh` + manual score against `suites/tool-use/rubric.md` |
| **Metric** | pass/fail per instance |
| **EXAMPLE score** | **3/4 pass** (instance-level; not aggregate-only) |

Layout mirrors [Inspect](https://inspect.aisi.org.uk/tasks.html) (dataset + solver + scorer). Instances are checkable like [SWE-bench](https://www.swebench.com/). Tool calls scored like [BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html). Headline % alone is not a report ([HELM](https://crfm.stanford.edu/helm/)).

## How to replace this file with a real run

1. Keep or swap the solver: default `./scripts/run.sh tool-use` (echo, no key), or `ADAPTER=fixture ./scripts/run.sh tool-use` (local JSON, no key). Any other `adapters/<name>.sh` uses the same contract.
2. Open the dated file `reports/tool-use-<YYYY-MM-DD>.md`.
3. Score **each** `{"calls":[...]}` block with `suites/tool-use/rubric.md` (worked examples are in that file).
4. Replace the Results table and the header fields above. Delete the word EXAMPLE. Do not copy these 3/4 numbers into a “live” report.

Stage 1 scaffold (no adapter traces): [tool-use-sample.md](tool-use-sample.md).

## EXAMPLE comparison (scaffold vs adapter fill)

| Fill | Instances | Trajectories | EXAMPLE score |
|---|---|---|---|
| [tool-use-sample.md](tool-use-sample.md) (Stage 1 scaffold) | 3 | none (manual rows) | **EXAMPLE 2/3** |
| this file (`echo` stub) | 4 | `{"calls":[...]}` | **EXAMPLE 3/4** |

Same suite and rubric. The fourth instance is withhold. Neither row is a prod metric, a model bake-off, or a staging-vs-prod comparison.

## Rubric (short)

See `suites/tool-use/rubric.md` at fill time:

- **pass:** exact name + required args + no extra tools; withhold when Expected is `{"calls":[]}`.
- **fail:** first matching mode (wrong tool, hallucinated args, missing arg, extra tool, silent no-op, over-call).
- **Does not measure:** latency, cost, multi-turn repair, tool return correctness, prompt injection, paid-model quality.

## Cases (ids)

1. Single correct tool — `What's the weather in Lisbon?` / `get_weather` only.
2. Refuse wrong tool — same prompt / `get_weather` + `send_email`.
3. Missing args — `What's the weather?` / fail-closed.
4. Withhold — no valid tool — Lisbon prompt / `send_email` only.

## EXAMPLE trajectories (`echo` stub)

### 1. Single correct tool

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Lisbon"}}]}
```

### 2. Refuse wrong tool

```json
{"calls":[{"name":"get_weather","arguments":{"city":"Lisbon"}}]}
```

### 3. Missing args

```json
{"calls":[{"name":"get_weather","arguments":{"city":"London"}}]}
```

### 4. Withhold — no valid tool

```json
{"calls":[]}
```

## EXAMPLE Results

| Case | Result | Notes |
|------|--------|-------|
| 1. Single correct tool | **EXAMPLE pass** | Exact `get_weather` + `city=Lisbon`; one call |
| 2. Refuse wrong tool | **EXAMPLE pass** | No `send_email`; same legal weather call |
| 3. Missing args | **EXAMPLE fail** / hallucinated args | Stub invented `city=London` — documented echo policy, not a model |
| 4. Withhold — no valid tool | **EXAMPLE pass** | Zero calls; did not substitute `send_email` |

**EXAMPLE score:** 3/4 pass. Do not cite this as a live eval.

## Incompleteness (HELM)

This EXAMPLE does **not** claim latency, cost, multi-turn recovery, parallel tool-calling skill, post-execution tool correctness, or any production traffic. It only shows how to fill instance rows after the default dry-run path.
