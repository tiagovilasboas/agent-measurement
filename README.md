# Agent Measurement

**PT** · Kit **pequeno e reproduzível** para medir sistemas agentic (tool-use, RAG vs MCP, prompts AppSec). Research = **medição**, não treino de modelo nem lista de papers.

**EN** · Tiny **reproducible** eval harness for agentic systems. Research as **measurement**, not model training or a paper dump.

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec

---

## Por quê / Why

Staff evidence de aprendizado: suites pequenas, resultados em markdown, critérios explícitos. Comunidade pode fork e rodar sem stack proprietário.

---

## Suites (esqueleto)

| Suite | Objetivo | Status |
|---|---|---|
| `tool-use` | Agent chama a tool certa (e só ela) | stub |
| `rag-vs-mcp` | Quando recuperar vs quando chamar tool | stub |
| `appsec-prompt` | Prompt de review não inventa achado | stub |

Pastas: `suites/<nome>/` · `reports/` · `scripts/run.sh`

---

## Como rodar / Run

```bash
# WIP — cada suite documenta o comando mínimo
./scripts/run.sh tool-use
```

Saída esperada: `reports/<suite>-<date>.md` com pass/fail e notas.

---

## Não é / Not

- Fine-tune / training pipeline
- Awesome list de papers
- Benchmark proprietário fechado

Ver também: [awesome-agentic-ai](https://github.com/tiagovilasboas/awesome-agentic-ai) · [agentic-code-review](https://github.com/tiagovilasboas/agentic-code-review)

---

## License

MIT
