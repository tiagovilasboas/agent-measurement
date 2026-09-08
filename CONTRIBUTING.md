# Contributing

This repository produces **reproducible evidence** that an agentic system does what it claims. A contribution is a tiny measurement unit — not a paper list, a fine-tune, or a closed leaderboard.

Quality bar (layout and reporting only; we do not vendor these harnesses):

- [Inspect](https://inspect.aisi.org.uk/tasks.html): a task is **dataset + solver + scorer**. Here that is `cases.md` + your agent + `rubric.md`.
- [SWE-bench](https://www.swebench.com/): each case is an **instance** — given input, expected outcome, independently checkable.
- [BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html): tool-use is scored on **exact name, required args, and withhold** when no valid tool exists.
- [HELM](https://crfm.stanford.edu/helm/): reports name the **metric**, keep **instance-level** rows, and state what the suite does **not** cover.

## Layout

```
suites/<suite-id>/
  cases.md    # dataset — numbered instances
  rubric.md   # scorer — pass/fail (or the named metric) and fail modes
adapters/     # solver stubs (`echo.sh` by default — no API key)
scripts/run.sh
reports/      # dry-run output + EXAMPLE fills (not prod metrics)
```

`<suite-id>` is kebab-case (`tool-use`, `rag-vs-mcp`, `appsec-prompt`).

## Add a suite

1. Create `suites/<suite-id>/cases.md` and `suites/<suite-id>/rubric.md`.
2. Add one row to the README suite table (id, what it measures, minimum metric).
3. Dry-run the new id (see below).
4. Open a PR using `.github/PULL_REQUEST_TEMPLATE.md`. Use the [Add suite](/.github/ISSUE_TEMPLATE/add-suite.yml) issue form when you want discussion first.

A suite stays **tiny**: a handful of instances, one explicit metric. The default adapter is the in-repo `echo` stub; adapters that call a paid model stay out of this repo unless they are key-free stubs.

## Add a case

Append a numbered instance to `suites/<suite-id>/cases.md`. Each instance states:

| Field | Required |
|---|---|
| **Given** | Prompt / context the agent sees |
| **Expected** | Observable action or answer (tool name, retrieve vs tool, `path:line`, …) |
| **Fail modes** | Wrong tool, invented args, silent no-op, finding without evidence, … |

SWE-bench framing: the instance is checkable without trusting the agent's prose. For `tool-use`, follow BFCL: the correct function (and only that function), required arguments present, no call when the right tool is missing. For `appsec-prompt`, score the `findings` JSON (`path` + `line`); withhold when the snippet does not prove a bug — do not invent a CWE.

## Add a rubric

`rubric.md` is the Inspect **scorer**. It must answer:

- What is a **pass** (and the named metric — usually pass/fail per instance)?
- What is a **fail** (wrong tool, missing justification, finding without `path:line`, …)?
- What this suite **does not** measure (HELM incompleteness — latency, cost, multi-turn, … stay out unless the rubric names them).

Keep scoring deterministic. Do not hide extra credit in the notes column.

## Dry-run

The runner writes a report scaffold via `adapters/${ADAPTER:-echo}.sh`. It does **not** call a paid model.

```bash
./scripts/run.sh tool-use
```

Replace `tool-use` with any suite id. Success: `Wrote reports/<suite-id>-<YYYY-MM-DD>.md` containing Rubric, Cases, adapter trajectories (tool-use), and an empty Results table.

Unknown suite:

```bash
./scripts/run.sh not-a-suite
# exits 1: Unknown suite: not-a-suite
```

EXAMPLE live fill (Stage 2, labeled sample numbers): [reports/tool-use-live.example.md](reports/tool-use-live.example.md) — EXAMPLE 3/4. Stage 1 scaffold: [reports/tool-use-sample.md](reports/tool-use-sample.md) — EXAMPLE 2/3. Optional CI: [`.github/workflows/dry-run.yml`](.github/workflows/dry-run.yml).

Do not commit dated dry-run scaffolds from local runs unless they are intentional samples. Do not present EXAMPLE rows as production metrics.

## Report discipline

After a real agent run, fill Results **per instance** (HELM: no aggregate-only score):

| Case | Result | Notes |
|------|--------|-------|
| 1. … | pass/fail | evidence (tool called, `path:line`, …) |

State model, harness, and date in the report header when you fill it. A headline % without rows is not a report. Name incompleteness (latency, cost, multi-turn, …) when the suite does not measure them.

## Done (tick before merge)

- [ ] `cases.md` and `rubric.md` exist for every suite touched
- [ ] Each case has given / expected / fail modes
- [ ] Rubric names the metric and the incompleteness
- [ ] Dry-run succeeds (`./scripts/run.sh <suite-id>`)
- [ ] README suite table updated if a suite was added
- [ ] Sample reports (if any) keep instance-level rows + incompleteness notes
- [ ] EXAMPLE / sample numbers are labeled; not presented as prod metrics
