# Teable community edition (AGPL-3.0) release.2026-11-12T07-40-49Z.1724 (app version 1.10.0),
# official image pinned by digest, plus a Railway start script.
ARG TEABLE_IMAGE=ghcr.io/teableio/teable-community:release.2026-11-12T07-40-49Z.1724@sha256:30c7a5dcd1e69364febf834c85b3b257897419613163e2fe29dbf1e2ab909db6
FROM ${TEABLE_IMAGE}
COPY --chmod=0755 railway-teable.sh /app/railway-teable.sh
COPY --chmod=0644 railway-bootstrap.mjs /app/railway-bootstrap.mjs
ENV PORT=3000
ENTRYPOINT ["/app/railway-teable.sh"]
