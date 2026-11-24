# Teable community edition (AGPL-3.0) release.2026-11-23T07-19-00Z.1727 (app version 1.10.0),
# official image pinned by digest, plus a Railway start script.
ARG TEABLE_IMAGE=ghcr.io/teableio/teable-community:release.2026-11-23T07-19-00Z.1727@sha256:c730b2c2f07d7255e641b8cfd0617c335218edb8393420e2842d1ec283008480
FROM ${TEABLE_IMAGE}
COPY --chmod=0755 railway-teable.sh /app/railway-teable.sh
COPY --chmod=0644 railway-bootstrap.mjs /app/railway-bootstrap.mjs
ENV PORT=3000
ENTRYPOINT ["/app/railway-teable.sh"]
