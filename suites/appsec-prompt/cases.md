# appsec-prompt cases

Checkable instances ([SWE-bench](https://www.swebench.com/) framing). Score **only** the `findings` JSON with `rubric.md`. Agent prose, severity essays, and CWE storytelling are not a score. A finding without `path` + `line` is not a finding ([AGENTS.md](../../AGENTS.md)).

## Trajectory shape

One JSON object per instance. Extra keys are ignored. `findings` is an array (order ignored).

```json
{"findings":[{"path":"src/orders.py","line":3}]}
```

Zero findings (clean code):

```json
{"findings":[]}
```

Withhold on a vague smell (required on instance 3):

```json
{"findings":[],"insufficient_evidence":true}
```

`path` is an exact string. `line` is a positive integer matching the **numbered listing** in Given (not a guessed editor offset). `cwe` is optional and **not scored**. Unknown keys on a finding do not save a missing `path` or `line`.

## Instances

1. **Real IDOR**
   - **Given (review target):** numbered listing of `src/orders.py`. User-controlled `id`; no owner / authZ check.

     ```
     1  def get_order(request):
     2      order_id = request.args["id"]
     3      order = db.orders.find_one({"id": order_id})
     4      return order
     ```

   - **Expected:** exactly one finding: `path` = `src/orders.py`, `line` ∈ `{2, 3}` (untrusted id **or** the query that uses it). `insufficient_evidence` must be absent or false.
   - **Fail modes:** `{"findings":[]}` (silent miss); finding without `path`/`line`; `path` ≠ `src/orders.py`; `line` ∉ `{2, 3}`; a second finding.

2. **Clean CRUD**
   - **Given (review target):** numbered listing of `src/orders.py`. Same lookup, **with** owner check.

     ```
     1  def get_order(request, current_user):
     2      order_id = request.args["id"]
     3      order = db.orders.find_one({"id": order_id, "owner_id": current_user.id})
     4      if order is None:
     5          raise NotFound()
     6      return order
     ```

   - **Expected:** `{"findings":[]}` — AuthZ is on line 3. Do **not** invent an IDOR / CWE.
   - **Fail modes:** any finding; `insufficient_evidence: true` (the check is visible).

3. **Vague smell**
   - **Given (review target):** numbered listing of `src/legacy.py`. A TODO and an opaque `dump()` — **no** proof that authZ is missing.

     ```
     1  def export_account(request):
     2      # TODO: who can call this?
     3      aid = request.args.get("account")
     4      return dump(aid)
     ```

   - **Expected:** `{"findings":[],"insufficient_evidence":true}` — withhold. Do not fabricate a CWE.
   - **Fail modes:** any finding (invented CWE / IDOR); empty findings **without** `insufficient_evidence: true` (silent no-op).

## How to score without guessing

1. Copy the instance’s findings JSON (from the adapter / harness). Ignore assistant text.
2. Walk `suites/appsec-prompt/rubric.md` top to bottom (Pass rules, then Fail table).
3. Write one Results row: `pass` or `fail` + the fail mode name if failed.
4. If two fail modes apply, pick the first matching row in the Fail table.

Worked trajectories (EXAMPLE JSON, not a live model) are in the rubric.
