FROM ghcr.io/nimbleflux/opencode-docker:1.18.33

COPY files/opencode.json /home/opencode/workspace/opencode.json
COPY files/opencode.json /home/opencode/.config/opencode/opencode.json
