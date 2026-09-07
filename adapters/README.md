# Adapters

Inspect [solver](https://inspect.aisi.org.uk/solvers.html) slot: given a suite id, emit trajectories. The scorer stays in `suites/<id>/rubric.md`.

## Contract

```
adapters/<name>.sh <suite-id>
```

- **stdout:** markdown (header + per-instance JSON `{"calls":[...]}`)
- **exit:** 0 on success; non-zero if the suite id is missing
- **default:** `echo` — script stub, **no API key**, not a model

`scripts/run.sh` calls `$ROOT/adapters/${ADAPTER:-echo}.sh`. Swap later with `ADAPTER=your-stub` once you add `adapters/your-stub.sh`. Do not put API keys in this repo.

## `echo`

Naive city-token rules for `tool-use` only. Other suites print a “no fixtures” line and omit trajectories. Policy and prompts are documented in `echo.sh` — keep them aligned with `suites/tool-use/cases.md`.
