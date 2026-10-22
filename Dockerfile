FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

RUN printf '#!/bin/bash\n\
set -a\n\
for f in /app/.env /.env /coolify/.env; do\n\
  if [ -f "$f" ]; then\n\
    . "$f"\n\
    break\n\
  fi\ndone\n\
set +a\n\
echo "HOST=$OPENCODE_SERVER_HOST PORT=$OPENCODE_SERVER_PORT AUTH=$OPENCODE_AUTH_ENABLED"\n\
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
