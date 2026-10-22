FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

RUN printf '#!/bin/bash\n\
echo "=== ENV DUMP ==="\n\
env | grep -E "OPENCODE|OPENROUTER" || echo "No relevant vars"\n\
echo "=== END DUMP ==="\n\
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
