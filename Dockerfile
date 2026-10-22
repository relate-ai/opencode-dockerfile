FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

COPY files/opencode.json /home/opencode/workspace/opencode.json
COPY files/entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
