// Registers the first Teable user (who becomes the instance admin) from ADMIN_EMAIL / ADMIN_PASSWORD
// as soon as the local API answers, then disables public sign-up. Does nothing once users exist.
const base = `http://127.0.0.1:${process.env.PORT || 3000}`;
const log = (m) => console.log(`[railway-teable] ${m}`);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const call = (path, opts = {}) => fetch(base + path, { ...opts, signal: AbortSignal.timeout(20_000) });

let up = false;
for (let i = 0; i < 1800 && !up; i++) {
  try {
    up = (await call("/health")).ok;
  } catch {}
  if (!up) await sleep(1000);
}
if (!up) {
  log("Teable did not answer /health within 30 minutes; first-admin bootstrap skipped");
  process.exit(0);
}

const json = { "Content-Type": "application/json" };
const credentials = JSON.stringify({ email: process.env.ADMIN_EMAIL, password: process.env.ADMIN_PASSWORD });
const res = await call("/api/auth/signup", { method: "POST", headers: json, body: credentials });
if (!res.ok) {
  // A user already exists (normal after the first start) or sign-up is closed: nothing to do.
  const detail = (await res.text()).slice(0, 200);
  log(`first-admin sign-up not applied (${res.status}); normal once an account exists. ${detail}`);
  process.exit(0);
}
log(`first admin created: ${process.env.ADMIN_EMAIL} (password: ADMIN_PASSWORD variable)`);
if (process.env.TEABLE_DISALLOW_SIGNUP === "false") process.exit(0);
const session = (res.headers.getSetCookie?.() || [res.headers.get("set-cookie") || ""]).map((c) => c.split(";")[0]).join("; ");
const patch = await call("/api/admin/setting", {
  method: "PATCH",
  headers: { ...json, cookie: session },
  body: JSON.stringify({ disallowSignUp: true }),
});
log(patch.ok ? "public sign-up disabled (invite people from a space)" : `could not disable sign-up (${patch.status})`);
