#!/bin/bash
echo "=== DEBUG PROBE START ==="
if [ -n "${OPENROUTER_API_KEY:-}" ]; then echo "OPENROUTER_API_KEY: SET(len=${#OPENROUTER_API_KEY})"; else echo "OPENROUTER_API_KEY: NOT_SET"; fi
echo "OPENCODE_LOG_LEVEL(env): ${OPENCODE_LOG_LEVEL:-unset}"
echo "OPENCODE_STORAGE_PATH: ${OPENCODE_STORAGE_PATH:-unset}"

echo "--- probe 1: openrouter chat stream=false ---"
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  curl -sS -m 25 -o /tmp/or1.json -w "HTTP %{http_code} time=%{time_total}s\n" \
    -X POST https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer ${OPENROUTER_API_KEY}" \
    -H "Content-Type: application/json" \
    -H "HTTP-Referer: https://opencode.ai/" -H "X-Title: opencode" \
    -d '{"model":"anthropic/claude-haiku-5.5","messages":[{"role":"user","content":"Say OK"}],"max_tokens":10,"stream":false}' || echo "curl exit=$?"
  head -c 400 /tmp/or1.json 2>/dev/null; echo
else
  echo "OPENROUTER_API_KEY NOT SET - skipped"
fi

echo "--- probe 2: openrouter chat stream=true (8s cap) ---"
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  timeout 8 curl -sS -N -o /tmp/or2.txt -w "HTTP %{http_code} time=%{time_total}s\n" \
    -X POST https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer ${OPENROUTER_API_KEY}" \
    -H "Content-Type: application/json" \
    -H "HTTP-Referer: https://opencode.ai/" -H "X-Title: opencode" \
    -d '{"model":"anthropic/claude-haiku-5.5","messages":[{"role":"user","content":"Say OK"}],"max_tokens":10,"stream":true}' || echo "curl exit=$? (timeout expected=124)"
  head -c 500 /tmp/or2.txt 2>/dev/null; echo
fi

echo "--- probe 3: opencode inference free model ---"
curl -sS -m 25 -o /tmp/oc3.json -w "HTTP %{http_code} time=%{time_total}s\n" \
  -X POST https://opencode.ai/inference/openai/v1/chat/completions \
  -H "Authorization: Bearer public" \
  -H "Content-Type: application/json" \
  -d '{"model":"mimo-v2.6-flash-free","messages":[{"role":"user","content":"Say OK"}],"max_tokens":10,"stream":false}' || echo "curl exit=$?"
head -c 400 /tmp/oc3.json 2>/dev/null; echo

echo "--- probe 4: opencode inference free model STREAM ---"
timeout 8 curl -sS -N -o /tmp/oc4.txt -w "HTTP %{http_code} time=%{time_total}s\n" \
  -X POST https://opencode.ai/inference/openai/v1/chat/completions \
  -H "Authorization: Bearer public" \
  -H "Content-Type: application/json" \
  -d '{"model":"mimo-v2.6-flash-free","messages":[{"role":"user","content":"Say OK"}],"max_tokens":10,"stream":true}' || echo "curl exit=$? (timeout expected=124)"
head -c 500 /tmp/oc4.txt 2>/dev/null; echo

echo "--- config files present ---"
for f in /home/opencode/.config/opencode/opencode.json /home/opencode/.config/opencode/opencode.jsonc /home/opencode/workspace/opencode.json /opencode.json /.opencode/opencode.json; do
  if [ -f "$f" ]; then echo "FOUND $f:"; head -c 300 "$f"; echo; else echo "absent: $f"; fi
done
echo "=== DEBUG PROBE END ==="

export OPENCODE_LOG_LEVEL="${OPENCODE_LOG_LEVEL:-debug}"
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"
