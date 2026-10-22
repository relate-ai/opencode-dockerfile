FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

# Create opencode.json config with working model
RUN mkdir -p /home/opencode/workspace && \
    cat > /home/opencode/workspace/opencode.json << 'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/anthropic/claude-haiku-5.5"
}
JSON

# Also create a wrapper that loads .env and tests network
RUN printf '#!/bin/bash\n\
echo "=== NETWORK TEST ==="\n\
curl -s -m 10 -o /dev/null -w "openrouter.ai: %{http_code} time=%{time_total}s\\n" https://openrouter.ai/api/v1/models 2>&1\n\
echo "=== CONFIG ==="\n\
cat /home/opencode/workspace/opencode.json 2>&1\n\
echo "=== END ==="\n\
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
