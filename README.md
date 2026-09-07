# Agent Measurement

Tiny reproducible eval harness for agentic systems — suites, named metrics, markdown reports.

Kit de evals: evidência reproduzível de que o agent faz o que promete.

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec

## Suites

| Suite | Objetivo | Métrica mínima |
|---|---|---|
| `tool-use` | Chama a tool certa (e só ela) | pass/fail por caso |
| `rag-vs-mcp` | Recuperar vs chamar tool | decisão correta + justificativa curta |
| `appsec-prompt` | Review não inventa achado | finding só com path:line |

## Dry-run

```bash
./scripts/run.sh tool-use
```

Default solver is [`adapters/echo.sh`](adapters/echo.sh) — script stub, **no API key**, not a model. Writes `reports/tool-use-<YYYY-MM-DD>.md` with rubric, cases, and echo trajectories. Unknown suite or adapter → exit 1. Swap later: `ADAPTER=your-stub ./scripts/run.sh tool-use`.

Worked EXAMPLE fill (labeled sample numbers, not prod): [reports/tool-use-live.example.md](reports/tool-use-live.example.md). Stage 1 scaffold: [reports/tool-use-sample.md](reports/tool-use-sample.md).

Each suite has `suites/<nome>/cases.md` (instances) and `suites/<nome>/rubric.md` (scorer). Adapter contract: [adapters/README.md](adapters/README.md).

Optional CI: [`.github/workflows/dry-run.yml`](.github/workflows/dry-run.yml) runs the same command on push/PR.

## Related

- [Inspect AI](https://inspect.aisi.org.uk/) / [inspect_evals](https://github.com/UKGovernmentBEIS/inspect_evals) — harness + suites (dataset + solver + scorer)
- [SWE-bench](https://github.com/SWE-bench/SWE-bench) — eval with checkable instances (Fail→Pass evidence)
- [BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html) — deterministic tool-call (exact name, required args, withhold)
- [HELM](https://crfm.stanford.edu/helm/) — named metric, instance-level rows, state what you do **not** measure
- [BrowserGym](https://github.com/ServiceNow/BrowserGym) + [AgentLab](https://github.com/ServiceNow/AgentLab) — ambiente + runner
- [Winder: harness comparison](https://winder.ai/ai-agent-harness-comparison/) — harness muda o score

This org: [awesome-agentic-ai](https://github.com/tiagovilasboas/awesome-agentic-ai) · [agentic-code-review](https://github.com/tiagovilasboas/agentic-code-review)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Agent notes: [AGENTS.md](AGENTS.md).

## License

MIT — see [LICENSE](LICENSE).
