#!/bin/bash
echo "=== NETWORK TEST ==="
curl -s -m 10 -o /dev/null -w "openrouter.ai: %{http_code} time=%{time_total}s\n" https://openrouter.ai/api/v1/models 2>&1
echo "=== CONFIG ==="
cat /home/opencode/workspace/opencode.json 2>&1
echo "=== END ==="
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"
