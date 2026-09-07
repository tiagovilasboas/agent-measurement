# Agent notes

Thin map for coding agents. Humans: [CONTRIBUTING.md](CONTRIBUTING.md).

## Suites layout

```
suites/<suite-id>/cases.md   # dataset (instances)
suites/<suite-id>/rubric.md  # scorer (pass/fail + incompleteness)
scripts/run.sh               # dry-run harness → reports/<suite-id>-<date>.md
reports/tool-use-sample.md   # filled example (Stage 1)
```

Existing ids: `tool-use`, `rag-vs-mcp`, `appsec-prompt`.

## Run

```bash
./scripts/run.sh tool-use
```

Writes a markdown scaffold. Does not call a model. Unknown suite → exit 1.

Optional CI: `.github/workflows/dry-run.yml`.

## Do

- Keep suites tiny; one named metric; instance-level Results rows.
- Score only against `rubric.md` (Inspect scorer). Cases are checkable instances (SWE-bench).
- Tool-use: exact name, required args, withhold if no valid tool (BFCL).
- Name what the suite does not measure (HELM).
- Prefer web refs to Inspect / SWE-bench / BFCL / HELM over inventing frameworks.

## Don't

- Do not train models, dump papers, or invent a closed leaderboard.
- Do not score from agent prose alone (`appsec-prompt` needs `path:line`).
- Do not commit to `main`; open a PR.
- Do not treat a headline % without instance rows as a report.
