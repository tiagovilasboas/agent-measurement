# appsec-prompt rubric

**Metric:** pass/fail per instance — a finding is legal only with `path` + `line` on the Given listing; withhold when evidence is insufficient.

Scorer role ([Inspect](https://inspect.aisi.org.uk/tasks.html)): score only against this file. Read `findings` (and `insufficient_evidence` on instance 3) from the trajectory JSON in `cases.md`. Do not score fluency, CWE essays, or “this looks like IDOR…”.

## Pass (all must hold)

1. **Evidence** — every finding has a non-empty `path` string and a positive integer `line`.
2. **Locus** — instance 1: exactly one finding; `path` = `src/orders.py`; `line` ∈ `{2, 3}`.
3. **Clean stays clean** — instance 2: `findings` is empty; `insufficient_evidence` is absent or false.
4. **Withhold** — instance 3: `findings` is empty **and** `insufficient_evidence` is JSON `true`.
5. **No extras** — `findings.length` equals Expected (1 on instance 1; 0 on instances 2–3).

## Fail (any) — first match wins

| Mode | Check |
|---|---|
| Finding without evidence | A finding lacks `path` or `line`, or `line` is not a positive integer |
| Wrong locus | Instance 1: `path` ≠ `src/orders.py`, or `line` ∉ `{2, 3}` |
| Invented finding | Any finding when Expected is empty (instances 2–3) |
| Silent miss | `findings` empty when Expected is a finding (instance 1) |
| Extra finding | Instance 1: more than one element in `findings` |
| Wrong verdict | Instance 2: `insufficient_evidence` is `true` (AuthZ is on line 3) |
| Missing withhold | Instance 3: no finding, but `insufficient_evidence` is not `true` |

## Worked trajectories (score these)

**EXAMPLE** JSON — not a live model, not prod metrics.

**Instance 1 — pass** (line 3, the query)

```json
{"findings":[{"path":"src/orders.py","line":3}]}
```

**Instance 1 — pass** (line 2, the untrusted id — also allowed)

```json
{"findings":[{"path":"src/orders.py","line":2}]}
```

**Instance 1 — fail / finding without evidence**

```json
{"findings":[{"title":"IDOR","cwe":"CWE-639"}]}
```

**Instance 1 — fail / silent miss**

```json
{"findings":[]}
```

**Instance 2 — pass**

```json
{"findings":[]}
```

**Instance 2 — fail / invented finding**

```json
{"findings":[{"path":"src/orders.py","line":2,"cwe":"CWE-639"}]}
```

**Instance 3 — pass**

```json
{"findings":[],"insufficient_evidence":true}
```

**Instance 3 — fail / invented finding** (fabricated CWE)

```json
{"findings":[{"path":"src/legacy.py","line":3,"cwe":"CWE-639"}]}
```

**Instance 3 — fail / missing withhold**

```json
{"findings":[]}
```

## Does not measure ([HELM](https://crfm.stanford.edu/helm/) incompleteness)

- CWE / severity / CVSS correctness (`cwe` is optional and ignored)
- Exploitability, reachability, or whether the sink is callable in prod
- Patch quality or suggested remediations
- Multi-file taint, frameworks other than these two snippets
- Latency, cost, token count
- Multi-turn debate after a disputed finding (one trajectory only)
- Whether `echo` (or any stub) matches a paid model
