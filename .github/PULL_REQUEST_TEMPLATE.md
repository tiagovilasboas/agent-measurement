## Why

<!-- What measurement gap does this close? One or two sentences. -->

## What

<!-- Files and instances touched. Suite id if adding/changing a suite. -->

- [ ] Suite / cases / rubric
- [ ] Sample report and/or dry-run docs / optional CI (if this PR is Stage 1+)
- [ ] Adapter stub / EXAMPLE live report (if this PR is Stage 2+)

## How to verify

```bash
./scripts/run.sh tool-use
```

<!-- Replace tool-use with the suite id you changed. Success: reports/<suite>-<date>.md is written (tool-use includes echo trajectories); unknown ids/adapters exit 1. -->

## Done

- [ ] `cases.md` + `rubric.md` present for every suite touched
- [ ] Rubric names the metric and incompleteness
- [ ] Dry-run command above succeeds
- [ ] README suite table updated if a suite was added
- [ ] Sample reports (if any) have instance-level rows + incompleteness
