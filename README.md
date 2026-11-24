# Deploy and Host Teable with Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/teable-110-no-code-postgres-database-com?referralCode=20H68q)

Teable is a no-code database with a spreadsheet interface built directly on PostgreSQL: grid, form, kanban, gallery and calendar views, formulas, real-time collaboration and an API, while your data stays in real Postgres tables. This template runs the Teable 1.10 community edition with PostgreSQL 18 and Redis.

## About Hosting Teable

Teable runs as one container that serves the web app, the API and a plugin server. Its records are ordinary PostgreSQL tables, so they stay queryable with SQL; Redis holds sessions, cache and background queues, and uploaded attachments are kept on a volume. This is the layout of upstream's standalone Docker setup.

Teable makes the first account that signs up the instance administrator. This template registers that account from your variables the moment the API is up, before the public URL serves visitors, and then closes public sign-up. It uses the AGPL community image, which contains no enterprise code.

## Common Use Cases

- Replace Airtable or shared spreadsheets with a collaborative database on PostgreSQL
- Track projects, content calendars, inventories or CRM pipelines in grid, kanban and calendar views
- Collect data with forms and analyse it with formulas and grouping
- Query and join Teable tables from SQL tools, BI dashboards or scripts
- Give automation tools such as n8n a REST API to your tables

## Dependencies for Teable Hosting

- Teable community edition 1.10.0 (`teable-community` image, release of 2026-10-26, pinned by digest)
- PostgreSQL 18 (Railway's `postgres-ssl` image)
- Redis 8.2

### Deployment Dependencies

- Teable source: https://github.com/teableio/teable
- Self-hosting docs: https://help.teable.ai/en/deployment/docker-compose
- Environment variables: https://help.teable.ai/en/deployment/env

### Implementation Details

| Service | What it does | Public |
|---|---|---|
| Teable | Web app, API and plugin server; migrations on start; attachments on a volume | yes |
| Postgres | Teable metadata and your tables | no |
| Redis | Sessions, cache and queues | no |

**First login**

1. Enter your e-mail in `ADMIN_EMAIL` when you deploy.
2. Open the **Teable** URL and sign in with `ADMIN_EMAIL` and the generated `ADMIN_PASSWORD` from the Teable service's Variables tab. This account is the instance admin.
3. Invite people from a space or base. Public sign-up is closed after the admin is created; reopen it in the admin panel's settings, or set `TEABLE_DISALLOW_SIGNUP=false` before the first deploy.

**E-mail.** Invitation and notification e-mails need SMTP (`BACKEND_MAIL_*`), which Railway allows only on the Pro plan. Without it, share invitation links from the UI.

**Custom domain.** Add it to the Teable service and set `PUBLIC_ORIGIN` to `https://{your-domain}`, then redeploy.

**Scaling and versions.** Teable stores attachments on its volume, so keep one replica. The image is pinned by tag and digest in `services/teable/Dockerfile`; Teable publishes a release almost every day. To upgrade, take a newer `release.*` tag of `ghcr.io/teableio/teable-community`, back up Postgres and redeploy; migrations run on start.

**Resources.** Measured idle on Railway: Teable 0.6–0.9 GB, Postgres 0.06–0.09 GB, Redis 0.03 GB; about 1 GB in total, roughly $10–15 per month. Teable is close to the Trial plan's 1 GB per-service limit, so Hobby is recommended.

**License.** Teable's apps are AGPL-3.0 and its packages MIT; the Teable name and logo are protected brand assets. The community image used here has no enterprise features or license checks. This is a community template; it is not affiliated with Teable, Inc.

### Why Deploy Teable on Railway?

Railway runs Teable, PostgreSQL and Redis in one project with private networking, HTTPS and volumes. You get a ready instance with the admin account created for you, and you can connect SQL tools to the same Postgres or add a domain from the dashboard.
