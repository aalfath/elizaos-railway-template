#!/bin/sh
# Railway wrapper for the official ElizaOS image.
set -eu

# Persist all state on the Railway volume mounted at /data.
export ELIZA_STATE_DIR="${ELIZA_STATE_DIR:-/data/state}"
export PGLITE_DATA_DIR="${PGLITE_DATA_DIR:-/data/db}"
mkdir -p "$ELIZA_STATE_DIR" "$PGLITE_DATA_DIR"

# Serve the dashboard in self-hosted mode: the UI only offers the local
# (non-cloud) runtime when the server tells it its own public URL.
if [ -z "${ELIZA_EXTERNAL_BASE_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export ELIZA_EXTERNAL_BASE_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

if [ -z "${ELIZA_API_TOKEN:-}" ]; then
  echo "[railway] ELIZA_API_TOKEN is not set; refusing to start an unauthenticated agent." >&2
  exit 1
fi

# Finish first-run setup with the default Eliza character once the API is up.
node /railway/first-run.mjs &

exec sh -c "exec ${APP_CMD_START}"
