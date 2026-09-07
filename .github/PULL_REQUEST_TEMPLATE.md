## Why

<!-- What measurement gap does this close? One or two sentences. -->

## What

<!-- Files and instances touched. Suite id if adding/changing a suite. -->

- [ ] Suite / cases / rubric only (no filled sample report, adapter, or extra harness)

## How to verify

```bash
./scripts/run.sh tool-use
```

<!-- Replace tool-use with the suite id you changed. Success: reports/<suite>-<date>.md is written; unknown ids exit 1. -->

## Done

- [ ] `cases.md` + `rubric.md` present for every suite touched
- [ ] Rubric names the metric and incompleteness
- [ ] Dry-run command above succeeds
- [ ] README suite table updated if a suite was added
