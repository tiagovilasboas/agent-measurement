# Agent notes

Thin map for coding agents. Humans: [CONTRIBUTING.md](CONTRIBUTING.md).

## Suites layout

```
suites/<suite-id>/cases.md   # dataset (instances)
suites/<suite-id>/rubric.md  # scorer (pass/fail + incompleteness)
scripts/run.sh               # dry-run harness → reports/<suite-id>-<date>.md
```

Existing ids: `tool-use`, `rag-vs-mcp`, `appsec-prompt`.

## Run

```bash
./scripts/run.sh tool-use
```

Writes a markdown scaffold. Does not call a model. Unknown suite → exit 1.

## Do

- Keep suites tiny; one named metric; instance-level Results rows.
- Score only against `rubric.md` (Inspect scorer). Cases are checkable instances (SWE-bench).
- Tool-use: exact name, required args, withhold if no valid tool (BFCL).
- Name what the suite does not measure (HELM).

## Don't

- Do not add filled sample reports, adapters, or CI in Stage 0 hygiene.
- Do not train models, dump papers, or invent a closed leaderboard.
- Do not score from agent prose alone (`appsec-prompt` needs `path:line`).
- Do not commit to `main`; open a PR.
