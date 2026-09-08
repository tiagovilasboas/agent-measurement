# Agent notes

Thin map for coding agents. Humans: [CONTRIBUTING.md](CONTRIBUTING.md).

## Suites layout

```
suites/<suite-id>/cases.md           # dataset (instances)
suites/<suite-id>/rubric.md          # scorer (pass/fail + incompleteness)
adapters/echo.sh                     # default solver stub (no API key)
adapters/fixture.sh                  # optional local fixture runner (no API key)
scripts/run.sh                       # cases → adapter → reports/<suite-id>-<date>.md
docs/decision-rag-vs-mcp.md          # retrieve vs tool-call (rag-vs-mcp)
reports/tool-use-live.example.md     # EXAMPLE filled live-style report (Stage 2)
reports/tool-use-sample.md           # Stage 1 scaffold example
```

Existing ids: `tool-use`, `rag-vs-mcp` (retrieve vs tool), `appsec-prompt`.

## Run

```bash
./scripts/run.sh rag-vs-mcp
./scripts/run.sh tool-use
# ADAPTER=echo ./scripts/run.sh rag-vs-mcp      # same default
# ADAPTER=fixture ./scripts/run.sh rag-vs-mcp   # local JSON fixtures; no API key
```

Writes rubric + cases + adapter trajectories. Does not call a paid model. Default CI stays on `echo`. Unknown suite or adapter → exit 1.

Optional CI: `.github/workflows/dry-run.yml`.

## Do

- Keep suites tiny; one named metric; instance-level Results rows.
- Score only against `rubric.md` (Inspect scorer). Cases are checkable instances (SWE-bench).
- Tool-use: exact name, required args, withhold if no valid tool (BFCL).
- rag-vs-mcp: retrieve vs tool-call (`path` + `doc`/`name`; assumption if ambiguous).
- Name what the suite does not measure (HELM).
- Prefer web refs to Inspect / SWE-bench / BFCL / HELM over inventing frameworks.

## Don't

- Do not train models, dump papers, or invent a closed leaderboard.
- Do not score from agent prose alone (`rag-vs-mcp` needs decision JSON; `appsec-prompt` needs `path:line`).
- Do not commit to `main`; open a PR.
- Do not treat a headline % without instance rows as a report.
- Do not invent live prod metrics; label EXAMPLE / sample numbers as such.
