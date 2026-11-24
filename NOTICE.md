# Notice

This repository is a Railway template package for Teable. It contains configuration and small start scripts written for this template (MIT-licensed); it does not contain Teable source code.

| Component | License | Used as |
|---|---|---|
| Teable community edition 1.10.0 | AGPL-3.0 (`apps/nestjs-backend`, `apps/nextjs-app`), MIT (`packages/*`), Copyright (c) 2023-2025 Teable, Inc.; brand assets excluded from the AGPL (section 7(e) additional terms) | Official image `ghcr.io/teableio/teable-community:release.2026-10-26T07-49-03Z.1718@sha256:99604e6d…`, extended with our start scripts; Teable's branding is left unchanged |
| PostgreSQL 18 | PostgreSQL License | `ghcr.io/railwayapp-templates/postgres-ssl:18.6` (Railway) |
| Redis 8.2 | RSALv2 / SSPLv1 / AGPLv3 | `redis:8.2.11` (official image, unmodified) |

The `ghcr.io/teableio/teable` image used by other templates is the enterprise build (`NEXTJS_DIR=enterprise/app-ee`) with code under Teable's commercial license; this template uses the community image instead. Source of the AGPL code: https://github.com/teableio/teable

## Upstream files checked

- `dockers/examples/standalone/docker-compose.yaml` and `.env`, `scripts/start.sh` (develop, 2026-11-24)
- `apps/nestjs-backend/src/configs/secrets/secret-specs.ts`, `secrets-policy.ts` (SECRET_KEY derivation)
- `apps/nestjs-backend/src/features/user/user.service.ts` (first user becomes admin, `disallowSignUp`)
- `packages/openapi/src/auth/signup.ts`, `packages/openapi/src/auth/types.ts`, `packages/openapi/src/admin/setting/update.ts`

Teable and the Teable logo are trademarks of Teable, Inc. This community template is not affiliated with or endorsed by Teable, Inc.
