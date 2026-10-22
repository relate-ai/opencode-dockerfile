FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

RUN printf '#!/bin/bash\n\
echo "=== NETWORK TEST ==="\n\
echo "DNS:"\n\
nslookup openrouter.ai 2>&1 | head -5\n\
echo "HTTPS:"\n\
curl -s -m 10 -o /dev/null -w "openrouter.ai: %{http_code} time=%{time_total}s\\n" https://openrouter.ai/api/v1/models 2>&1\n\
echo "opencode.ai:"\n\
curl -s -m 10 -o /dev/null -w "opencode.ai: %{http_code} time=%{time_total}s\\n" https://opencode.ai 2>&1\n\
echo "=== END NETWORK TEST ==="\n\
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
