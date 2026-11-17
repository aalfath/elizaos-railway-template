// Completes ElizaOS first-run setup with the default "Eliza" character preset
// on a fresh volume, so the self-hosted dashboard opens straight to the app.
// Runs once in the background; does nothing when setup is already complete.
const port = process.env.PORT || process.env.ELIZA_PORT || "2138";
const base = `http://127.0.0.1:${port}`;
const headers = {
  Authorization: `Bearer ${process.env.ELIZA_API_TOKEN}`,
  "Content-Type": "application/json",
};
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function get(path, auth = true) {
  const res = await fetch(base + path, auth ? { headers } : {});
  if (!res.ok) throw new Error(`${path} -> ${res.status}`);
  return res.json();
}

async function main() {
  for (let i = 0; i < 180; i++) {
    try {
      const h = await get("/api/health", false);
      if (h.ready) break;
    } catch {}
    await sleep(5000);
  }
  const status = await get("/api/first-run/status");
  if (status.complete) {
    console.log("[railway] first-run already complete");
    return;
  }
  const options = await get("/api/first-run/options");
  const p = (options.styles || []).find((s) => s.id === "eliza") || options.styles?.[0] || {};
  const name = process.env.ELIZA_AGENT_NAME || p.name || "Eliza";
  const body = {
    name,
    presetId: p.id,
    avatarIndex: p.avatarIndex,
    bio: p.bio,
    systemPrompt: p.system,
    adjectives: p.adjectives,
    topics: p.topics,
    style: p.style,
    postExamples: p.postExamples,
    messageExamples: p.messageExamples,
  };
  const res = await fetch(base + "/api/first-run", { method: "POST", headers, body: JSON.stringify(body) });
  console.log(`[railway] first-run setup for "${name}": ${res.status} ${await res.text()}`);
}

main().catch((e) => console.error(`[railway] first-run helper: ${e.message}`));
