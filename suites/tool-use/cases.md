# tool-use cases

1. **Single correct tool** — User asks for weather in city X; only `get_weather` must be called.
2. **Refuse wrong tool** — User asks for weather; agent must not call `send_email`.
3. **Missing args** — Required `city` omitted; agent must ask or fail closed, not invent.
