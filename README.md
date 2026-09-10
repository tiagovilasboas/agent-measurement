# Agent Measurement

Tiny reproducible eval harness for agentic systems — suites, named metrics, markdown reports.

Kit de evals: evidência reproduzível de que o agent faz o que promete.

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec

## Suites

| Suite | Objetivo | Métrica mínima |
|---|---|---|
| `tool-use` | Chama a tool certa (e só ela) | pass/fail por caso ([BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html): name, args, withhold) |
| `rag-vs-mcp` | Decisão **retrieve vs tool-call** (corpus estático vs estado live/MCP) | path + justificativa; ver [docs/decision-rag-vs-mcp.md](docs/decision-rag-vs-mcp.md) |
| `appsec-prompt` | Review não inventa achado | finding só com `path:line`; withhold se evidência insuficiente |
| `appsec-withhold` | Agent não revela secrets do prompt | pass/fail; fixture JSON `action=withhold` ([docs](docs/appsec-withhold.md)) |

Score only against `suites/<id>/rubric.md` ([Inspect](https://inspect.aisi.org.uk/) scorer). Cases are checkable instances ([SWE-bench](https://github.com/SWE-bench/SWE-bench)). This is an eval harness — not a HITL review queue.

## Dry-run

```bash
./scripts/run.sh rag-vs-mcp
./scripts/run.sh tool-use
```

Same commands on push/PR: [`.github/workflows/dry-run.yml`](.github/workflows/dry-run.yml) (echo + `"calls"` / no fixtures). Default [`adapters/echo.sh`](adapters/echo.sh) — no API key. Unknown suite or adapter → exit 1.

Retrieve vs tool-call: `rag-vs-mcp` ([docs/decision-rag-vs-mcp.md](docs/decision-rag-vs-mcp.md)). Secret withhold (fixture, not echo-only): `appsec-withhold` ([docs/appsec-withhold.md](docs/appsec-withhold.md); CI fails if cases, rubric, fixture JSON, or the sample report is missing). EXAMPLE fills (not prod): [live 3/4](reports/tool-use-live.example.md) · [scaffold 2/3](reports/tool-use-sample.md) · [appsec-withhold fixture 3/3](reports/appsec-withhold-sample.md). Optional local swap (still no key): `ADAPTER=fixture ./scripts/run.sh tool-use` or `rag-vs-mcp` or `appsec-withhold`. Contract: [adapters/README.md](adapters/README.md).

## Related

- [Inspect AI](https://inspect.aisi.org.uk/) / [inspect_evals](https://github.com/UKGovernmentBEIS/inspect_evals) — harness + suites (dataset + solver + scorer)
- [SWE-bench](https://github.com/SWE-bench/SWE-bench) — eval with checkable instances (Fail→Pass evidence)
- [BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html) — deterministic tool-call (exact name, required args, withhold)
- [HELM](https://crfm.stanford.edu/helm/) — named metric, instance-level rows, state what you do **not** measure
- [BrowserGym](https://github.com/ServiceNow/BrowserGym) + [AgentLab](https://github.com/ServiceNow/AgentLab) — ambiente + runner
- [Winder: harness comparison](https://winder.ai/ai-agent-harness-comparison/) — harness muda o score

This org (kits, not prod scores from this harness):

- [awesome-agentic-ai § Cost / latency / evidence](https://github.com/tiagovilasboas/awesome-agentic-ai#cost--latency--evidence) — evals as evidence; that list does not publish first-party prod numbers
- [agentic-code-review § Start](https://github.com/tiagovilasboas/agentic-code-review#start-in-15-minutes) — AppSec `path:line` ([evidence required](https://github.com/tiagovilasboas/agentic-code-review/blob/main/guardrails/evidence-required.md); pairs with `appsec-prompt`; related to `appsec-withhold`, different metric)
- [jarvis-architecture ADR 0005](https://github.com/tiagovilasboas/jarvis-architecture/blob/main/docs/adr/0005-ops-owns-reconstruction.md) — ops is the measurement plane ([eval-red](https://github.com/tiagovilasboas/jarvis-architecture/blob/main/docs/cookbook-handoff.md#ops-failure)); score here, not in a host HUD
- [kiro-crew § Start](https://github.com/tiagovilasboas/kiro-crew#start) — Reviewer `path:line` or LGTM; Ops records CI (not a suite score)
- [grok-bot-architecture token economy](https://github.com/tiagovilasboas/grok-bot-architecture/blob/main/docs/token-economy.md) — no first-party prod numbers; [Obs](https://github.com/tiagovilasboas/grok-bot-architecture/blob/main/docs/crew/roles.md#obs) traces/evals point here

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Agent notes: [AGENTS.md](AGENTS.md).

## License

MIT — see [LICENSE](LICENSE).
