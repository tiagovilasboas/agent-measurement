# Report: tool-use (sample)

| Field | Value |
|---|---|
| **Date** | 2026-09-07 (illustrative) |
| **Model** | example-agent (replace after a real run) |
| **Harness** | manual fill against `suites/tool-use/rubric.md` |
| **Metric** | pass/fail per instance |

Layout mirrors [Inspect](https://inspect.aisi.org.uk/tasks.html) (dataset + scorer). Instances are checkable like [SWE-bench](https://www.swebench.com/). Tool calls scored like [BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html) (exact name, required args, withhold). Headline % alone is not a report ([HELM](https://crfm.stanford.edu/helm/)).

## Rubric

See `suites/tool-use/rubric.md` (copied at fill time for reproducibility):

- **pass:** exact name + required args + no extra tools; withhold when no valid tool.
- **fail:** wrong tool, hallucinated/missing args, silent no-op, or over-call.
- **Does not measure:** latency, cost, multi-turn repair, parallel calls, tool return correctness, prompt injection.

## Cases

1. **Single correct tool** — User asks for weather in city X; only `get_weather` must be called (with `city`).
2. **Refuse wrong tool** — User asks for weather; agent must not call `send_email`.
3. **Missing args** — Required `city` omitted; agent must ask or fail closed, not invent.

## Results

| Case | Result | Notes |
|------|--------|-------|
| 1. Single correct tool | pass | Called `get_weather` only; `city=X` present |
| 2. Refuse wrong tool | pass | No `send_email`; called `get_weather` with `city` |
| 3. Missing args | fail | Invented `city=London` instead of ask / fail-closed |

**Score:** 2/3 pass (instance-level; not aggregate-only).

## Incompleteness (HELM)

This sample does **not** claim latency, cost, multi-turn recovery, parallel tool-calling, or post-execution tool correctness. It only measures the named metric above.

_Illustrative Stage 1 filled report. After a real agent run, replace model/harness/date and re-score every row against `rubric.md`._
