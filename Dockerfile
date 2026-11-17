# ElizaOS — official image from the elizaOS/eliza GitHub Container Registry.
# Pinned by tag and digest; bump both together (see CHANGELOG.md).
FROM ghcr.io/elizaos/eliza:sha-9e36ceb@sha256:9efd032a9366c376138c4231708857356c4c19dd1a2889e9f9bc116b1bc5e566

ENV ELIZA_API_BIND=0.0.0.0 \
    ELIZA_STATE_DIR=/data/state \
    PGLITE_DATA_DIR=/data/db

COPY start.sh first-run.mjs /railway/

# The upstream ENTRYPOINT (packages/app-core/scripts/docker-entrypoint.sh) maps
# PORT to the agent's API port and then runs this command.
CMD ["sh", "/railway/start.sh"]
