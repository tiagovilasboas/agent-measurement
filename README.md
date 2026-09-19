# Agent Measurement

Reproducible **eval harness** for agentic systems: suites + rubrics + adapters + markdown reports.

Maintainer: [Tiago Vilas Boas](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec

## Purpose

Measure whether the agent did what it promised. A suite is a tiny Inspect-shaped task: `cases.md` (dataset) + adapter (solver) + `rubric.md` (scorer). `./scripts/run.sh <suite>` writes a markdown report you score instance by instance.

This repo is **not** model training, **not** a HITL review product, and **not** a sibling-kit hub. It is the harness.

## Value

- **Dev:** `./scripts/run.sh <suite>` produces a checkable report. `./scripts/check-contract.sh` and CI fail if the rubric / cases / (gated) fixture / sample-report contract breaks. Default adapter needs no API key.
- **Community:** the Inspect mental model (dataset + solver + scorer) without installing Inspect in CI.

## Suites

| Suite | Decision | Metric |
|---|---|---|
| `rag-vs-mcp` | retrieve vs tool-call (static corpus vs live/MCP-shaped state) | `path` + `doc`/`name`; `assumption` if ambiguous ([docs](docs/decision-rag-vs-mcp.md)) |
| `tool-use` | call the right tool, and only it | pass/fail ([BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html): name, args, withhold) |
| `appsec-prompt` | review does not invent a finding | finding only with `path:line`; withhold if evidence is insufficient |
| `appsec-withhold` | agent does not reveal secrets from the prompt | `action=withhold`, `leaked=[]` ([docs](docs/appsec-withhold.md)) |

Score only against `suites/<id>/rubric.md`. Cases are checkable instances. Score is not implied by adapter prose.

## Run it

Default adapter is [`adapters/echo.sh`](adapters/echo.sh) — keyless stub, not a model. Swap locally with `ADAPTER=fixture` (still no key). Unknown suite or adapter → exit 1.

```bash
./scripts/run.sh rag-vs-mcp
./scripts/run.sh tool-use
ADAPTER=fixture ./scripts/run.sh rag-vs-mcp
ADAPTER=fixture ./scripts/run.sh appsec-withhold
./scripts/check-contract.sh
```

Same commands on push/PR: [`.github/workflows/dry-run.yml`](.github/workflows/dry-run.yml). Gated suites (`rag-vs-mcp`, `appsec-withhold`): missing `cases.md`, `rubric.md`, fixture JSON, or the sample report fails `check-contract.sh` and CI. Adapter contract: [adapters/README.md](adapters/README.md).

Worked EXAMPLE fills (not prod): [rag-vs-mcp fixture](reports/rag-vs-mcp-sample.md) · [appsec-withhold fixture](reports/appsec-withhold-sample.md) · [tool-use live 3/4](reports/tool-use-live.example.md) · [tool-use scaffold 2/3](reports/tool-use-sample.md).

### Expected FAIL

These paths are **supposed** to exit 1. CI asserts that — a green dry-run that never fails closed is not a contract.

```bash
# Unknown suite (missing cases.md)
./scripts/run.sh not-a-suite
# → exit 1: Unknown suite: not-a-suite (missing .../cases.md)

# Missing rubric (same runner). CI hides suites/rag-vs-mcp/rubric.md and expects:
# → exit 1: Missing rubric: rag-vs-mcp (missing .../rubric.md)

# Broken contract (gated fixture or sample report missing). CI hides
# reports/rag-vs-mcp-sample.md and expects:
./scripts/check-contract.sh
# → exit 1: contract: missing reports/rag-vs-mcp-sample.md (gated suite rag-vs-mcp)
```

On `tool-use`, default `echo` also emits a **documented instance fail**: instance 3 invents `city=London` instead of withhold. That is stub policy, not a paid-model miss. On `rag-vs-mcp`, the teaching fail is stale retrieve (dated README as “3 open PRs”) — in the rubric and in the sample report, not in the pass-shape fixture.

## Limit

- Does not train or fine-tune a model.
- Does not install or vendor Inspect, SWE-bench, or BFCL. Those links are shape/inspiration; CI stays keyless.
- Does not publish live prod leak rates or bake-off percentages. EXAMPLE rows stay labeled.
- A headline % without instance-level Results rows is not a report.
- Suites do not measure latency, cost, multi-turn repair, RAG quality, or MCP SDK conformance unless a rubric names them.

## Official refs

Shape of this harness, **not** runtime dependencies:

- [Inspect](https://inspect.aisi.org.uk/) — Task = dataset + solver + scorer ([tutorial](https://inspect.aisi.org.uk/tutorial.html))
- [SWE-bench](https://github.com/SWE-bench/SWE-bench) — checkable instances (given input, expected outcome)
- [BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html) — exact name, required args, withhold
- [HELM](https://crfm.stanford.edu/helm/) — named metric, instance rows, state incompleteness

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Agent notes: [AGENTS.md](AGENTS.md).

## License

MIT — see [LICENSE](LICENSE).
