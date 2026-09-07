# Agent Measurement

## Purpose / Propósito

**PT:** Gerar **evidência reproduzível** de que um sistema agentic faz o que promete — suites pequenas, métricas explícitas, relatório em markdown. Aqui “research” = **medir** (tool-use, RAG vs MCP, prompts AppSec), não treinar modelo nem listar papers.

**EN:** Produce **reproducible evidence** that an agentic system does what it claims — tiny suites, explicit metrics, markdown reports. “Research” here means **measurement** (tool-use, RAG vs MCP, AppSec prompts), not model training or paper lists.

**Não é / Not:** fine-tune pipeline · awesome de papers · leaderboard fechado.

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec

---

## Suites

| Suite | Objetivo | Métrica mínima |
|---|---|---|
| `tool-use` | Chama a tool certa (e só ela) | pass/fail por caso |
| `rag-vs-mcp` | Recuperar vs chamar tool | decisão correta + justificativa curta |
| `appsec-prompt` | Review não inventa achado | finding só com path:line |

---

## Quick start

```bash
./scripts/run.sh tool-use
# writes reports/tool-use-<date>.md
```

Cada suite tem `suites/<nome>/cases.md` (casos) e `suites/<nome>/rubric.md` (como pontuar).

---

## Inspired by

- [Inspect AI](https://inspect.aisi.org.uk/) / [inspect_evals](https://github.com/UKGovernmentBEIS/inspect_evals) — harness + suites
- [SWE-bench](https://github.com/SWE-bench/SWE-bench) — eval com evidência Fail→Pass
- [BFCL](https://gorilla.cs.berkeley.edu/leaderboard.html) — tool-call determinístico
- [BrowserGym](https://github.com/ServiceNow/BrowserGym) + [AgentLab](https://github.com/ServiceNow/AgentLab) — ambiente + runner
- [Winder: harness comparison](https://winder.ai/ai-agent-harness-comparison/) — harness muda o score

Related: [awesome-agentic-ai](https://github.com/tiagovilasboas/awesome-agentic-ai) · [agentic-code-review](https://github.com/tiagovilasboas/agentic-code-review)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Agent notes: [AGENTS.md](AGENTS.md).

## License

MIT — see [LICENSE](LICENSE).
