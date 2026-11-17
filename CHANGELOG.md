# Changelog

## 2026-11-17 — ElizaOS stable `sha-9e36ceb` (first release)

- Image: `ghcr.io/elizaos/eliza:sha-9e36ceb@sha256:9efd032a9366c376138c4231708857356c4c19dd1a2889e9f9bc116b1bc5e566`, upstream's current `stable` tag (packages report 2.0.4 / agent 2.0.3-beta.7). The newer npm release v2.0.5 has no published container image yet, and the `v2.0.3` image fails to start (missing `@elizaos/tui` build output).
- State on a volume at `/data` (`ELIZA_STATE_DIR=/data/state`, `PGLITE_DATA_DIR=/data/db`).
- Dashboard served in self-hosted mode with pairing-code login; first-run setup completed automatically with the default "Eliza" character.
