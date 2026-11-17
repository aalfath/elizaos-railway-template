# ElizaOS on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/elizaos?utm_medium=integration&utm_source=button&utm_campaign=elizaos)

A one-click Railway template for [ElizaOS](https://github.com/elizaOS/eliza) (MIT), the open-source agent framework and app from elizaOS. It runs the agent server and its web dashboard as one service with a persistent volume.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| `ElizaOS` | this repo (`Dockerfile`) | Official image `ghcr.io/elizaos/eliza:sha-9e36ceb` (upstream's current `stable` tag), pinned by digest. Volume at `/data`. Health check `/api/health`. |

- The agent keeps its config, character, plugins, skills, wallets and its embedded PGlite database on the volume (`/data/state` and `/data/db`), so data survives redeploys and restarts.
- First-run setup completes itself on a fresh volume with the default "Eliza" character, so the dashboard opens straight to the app instead of the Eliza Cloud sign-in.
- The dashboard and API are locked behind `ELIZA_API_TOKEN`. A browser joins with a one-time pairing code that the server prints in the deploy logs.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `ELIZA_API_TOKEN` | `${{secret(48)}}` | API token for the agent. Also needed for API clients (`Authorization: Bearer …`). |
| `ELIZA_VAULT_PASSPHRASE` | `${{secret(32)}}` | Encrypts the agent's local secret vault (wallet keys, saved credentials). Don't change it after the first deploy. |
| `PORT` | `8080` | Port the agent listens on behind Railway's proxy. |
| `OPENAI_API_KEY` | optional | Model provider key. Set at least one provider key so the agent can answer. |
| `ANTHROPIC_API_KEY` | optional | Model provider key. |
| `OPENROUTER_API_KEY` | optional | Model provider key. |

Other providers and connectors (Discord, Telegram and more) can be added later as variables or in the dashboard settings.

## After deploy

1. Open the service's Railway URL. It shows **Pairing Required**.
2. In Railway, open the service's **Deploy Logs** and find the line `Pairing code: XXXX-XXXX (valid for 10 minutes)`. Enter that code in the browser. Reload the page if the code has expired; a new code is logged.
3. If you didn't set a provider key, add one as a service variable (or under Settings in the dashboard) and redeploy.

## Updates

The service builds from this repository. When we bump the pinned ElizaOS image here, Railway shows an "update available" notice in your project, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first; breaking changes are listed at the top of each entry.

## Files

- `Dockerfile` — pins the official image and adds the small Railway wrapper.
- `start.sh` — keeps state on `/data`, tells the dashboard its public URL, refuses to start without a token.
- `first-run.mjs` — completes first-run setup once with the default character.
