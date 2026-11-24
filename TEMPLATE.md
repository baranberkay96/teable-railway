# Teable 1.10 No-Code Postgres Database (Community, Redis): composer spec

## Listing

| Field | Value |
|---|---|
| Name | **Teable 1.10 No-Code Postgres Database (Community, Redis)** |
| Description | Airtable-style spreadsheet UI on PostgreSQL, community edition. (63 chars) |
| Category | Other |
| Icon | `https://cdn.jsdelivr.net/gh/selfhst/icons@main/png/teable.png` |
| Repo | `baranberkay96/teable-railway`, root `/services/teable` |

Version label: app version 1.10.0 (`package.json`); Teable ships date-stamped `release.*` image tags.

## Base market templates (checked 2026-11-24)

| Code | Deploys | Notes |
|---|---|---|
| `wada5e` | 981 | `ghcr.io/teableio/teable` (enterprise build) untagged with auto-updates, Postgres `:latest` with public TCP proxy, no Redis; first visitor becomes admin |
| `NtH5uD` | 60 | Enterprise build, MinIO `:latest` + console, Redis with public proxy |
| `teable-production` | 5 | Enterprise build pinned by tag, Postgres 17, Redis, mail and cipher variables |

## Services

| Service | Source | Port | Healthcheck | Volume |
|---|---|---|---|---|
| Teable | repo `/services/teable` (`FROM ghcr.io/teableio/teable-community:release.2026-10-26T07-49-03Z.1718@sha256:99604e6d…`) | 3000 public | `/health` (900 s) | `/app/.assets` |
| Postgres | `postgres-ssl:18.6` | 5432 private | — | `/var/lib/postgresql/data` |
| Redis | `redis:8.2.11` | 6379 private | — | `/data` |

## Design

1. **Community (AGPL) image**, not the enterprise build the market templates use. Pinned to the 2026-10-26 community release: on Railway the newest one (`release.2026-11-23T07-19-00Z.1727`) crashed with `Cannot find module 'neverthrow'` and `release.2026-11-12T07-40-49Z.1724` never finished booting (`unregistered dependency token v2.commandExplain.previewPlannerRegistry`); the recent community builds miss parts of the new v2 core.
2. **First admin (8.37):** Teable's first sign-up becomes the instance admin. `railway-bootstrap.mjs` polls `127.0.0.1:$PORT/health` every second and posts `/api/auth/signup` with `ADMIN_EMAIL` / `ADMIN_PASSWORD` immediately, i.e. while Railway's own healthcheck is still promoting the deployment, then sets `disallowSignUp` through `/api/admin/setting` with the new session. On later starts the sign-up is refused and nothing changes.
3. **Secrets:** a single `SECRET_KEY` (Teable derives JWT, session, invitation and cipher keys from it per `secret-specs.ts`).
4. **Deploy-form values (8.29):** empty optional variables dropped; bad `PUBLIC_ORIGIN` → Railway domain; short/missing `SECRET_KEY` → stable value derived from the database URL; invalid `ADMIN_EMAIL` → `admin@example.com`; a password Teable would reject → random (logged), so the deploy never fails.
5. Upstream standalone layout (Teable + Postgres + Redis, attachments on a volume); Postgres and Redis private; Redis with `?family=0`.

## Improvements over market templates

- AGPL community image pinned by digest instead of the enterprise build on auto-update.
- Admin created from variables and sign-up closed; no claimable first sign-up.
- Redis included; no public database or Redis proxies; healthcheck; deploy-form typos do not fail the boot.

## Resources

To be measured on the test deploy (see the report).

## Verification checklist

- [ ] All services SUCCESS; `/health` 200.
- [ ] Admin sign-in; create a base, table and record; upload an attachment.
- [ ] Stranger sign-up refused.
- [ ] Odd values (`ADMIN_PASSWORD=abc`, bad e-mail) do not fail the deploy.

## Open questions

- SMTP (Pro only) not tested.
