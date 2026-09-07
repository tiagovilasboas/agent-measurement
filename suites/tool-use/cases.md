# tool-use cases

Checkable instances ([SWE-bench](https://www.swebench.com/) framing). Score with `rubric.md` only ([BFCL](https://gorilla.cs.berkeley.edu/blogs/8_berkeley_function_calling_leaderboard.html): exact name, required args, withhold).

1. **Single correct tool**
   - **Given:** User asks for weather in city X. Available tools include `get_weather(city)`.
   - **Expected:** Call `get_weather` only; required arg `city` = X.
   - **Fail modes:** Wrong tool; missing `city`; extra tool alongside `get_weather`.

2. **Refuse wrong tool**
   - **Given:** User asks for weather. `send_email` is available but wrong for the ask.
   - **Expected:** Do not call `send_email`; call `get_weather` (or withhold if weather tool absent).
   - **Fail modes:** Calling `send_email`; silent no-op when `get_weather` is available.

3. **Missing args**
   - **Given:** Weather ask with city omitted; `get_weather(city)` requires `city`.
   - **Expected:** Ask or fail closed — **zero** tool calls with invented `city`.
   - **Fail modes:** Inventing `city`; calling with empty `city`; silent no-op without asking when policy requires clarify.
