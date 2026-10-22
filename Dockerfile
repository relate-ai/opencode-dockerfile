FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

RUN printf '#!/bin/bash\n\
echo "=== ENV DUMP ==="\n\
env | grep -i OPENCODE || echo "No OPENCODE vars in env"\n\
echo "=== FIND .env FILES ==="\n\
find / -name ".env" -o -name "env" -path "*/coolify/*" 2>/dev/null | head -10\n\
echo "=== CHECK COMMON PATHS ==="\n\
for f in /coolify/env /coolify/.env /etc/coolify/env /app/.env /.env /run/secrets/*; do\n\
  if [ -f "$f" ]; then echo "FOUND: $f"; head -5 "$f"; fi\ndone\n\
echo "=== MOUNTS ==="\n\
cat /proc/mounts | grep -v cgroup | head -20\n\
echo "=== END DUMP ==="\n\
exec opencode serve --hostname "${OPENCODE_SERVER_HOST:-0.0.0.0}" --port "${OPENCODE_SERVER_PORT:-4000}" "$@"\n\
' > /entrypoint-wrapper.sh && chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
