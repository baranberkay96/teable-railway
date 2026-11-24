# Teable community edition (AGPL-3.0) release.2026-10-26T07-49-03Z.1718 (app version 1.10.0),
# official image pinned by digest, plus a Railway start script.
ARG TEABLE_IMAGE=ghcr.io/teableio/teable-community:release.2026-10-26T07-49-03Z.1718@sha256:99604e6dd15e47184e167bf3e0006945d6d4ebb5f9449d62c443beefb301ce48
FROM ${TEABLE_IMAGE}
COPY --chmod=0755 railway-teable.sh /app/railway-teable.sh
COPY --chmod=0644 railway-bootstrap.mjs /app/railway-bootstrap.mjs
ENV PORT=3000
ENTRYPOINT ["/app/railway-teable.sh"]
