FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

# Create a wrapper script that sources .env and starts OpenCode
RUN printf '#!/bin/sh\n\
if [ -f /app/.env ]; then\n\
  set -a\n\
  . /app/.env\n\
  set +a\n\
fi\n\
exec opencode serve "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
