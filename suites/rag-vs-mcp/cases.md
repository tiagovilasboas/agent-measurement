# rag-vs-mcp cases

1. **Static fact in corpus** — Prefer retrieve; do not call live API.
2. **Live state** — Prefer MCP/tool (e.g. "open PRs now"); do not answer from stale RAG alone.
3. **Ambiguous** — Agent states assumption and chooses one path explicitly.
