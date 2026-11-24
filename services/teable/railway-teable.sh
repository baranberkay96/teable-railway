#!/bin/bash
# Railway start script for Teable.
# - repairs deploy-form values that would stop the boot (STANDARD 8.29)
# - starts Teable (migrations, API, plugin server) and, on a fresh database, registers the first
#   user (= instance admin) from ADMIN_EMAIL / ADMIN_PASSWORD the moment the API answers, then
#   turns off public sign-up (STANDARD 8.37)
set -u
cd /app
log() { echo "[railway-teable] $*"; }

for var in $(env | sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=$/\1/p'); do unset "$var"; done
case "${PORT:-}" in ''|*[!0-9]*) export PORT=3000 ;; esac
case "${PUBLIC_ORIGIN:-}" in
  http://?*|https://?*) ;;
  *) export PUBLIC_ORIGIN="https://${RAILWAY_PUBLIC_DOMAIN:-localhost}"; log "WARNING: PUBLIC_ORIGIN is not a URL; using $PUBLIC_ORIGIN" ;;
esac
SECRET_KEY="${SECRET_KEY:-}"
if [ "${#SECRET_KEY}" -lt 16 ]; then
  export SECRET_KEY="$(printf '%s' "teable:${PRISMA_DATABASE_URL:-}" | sha256sum | cut -c1-64)"
  log "WARNING: SECRET_KEY is missing or shorter than 16 characters; using a value derived from the database URL. Set a long random SECRET_KEY."
fi

ADMIN_EMAIL="$(printf '%s' "${ADMIN_EMAIL:-}" | tr -d ' \t' | tr 'A-Z' 'a-z')"
if ! printf '%s' "$ADMIN_EMAIL" | grep -Eq '^[^@ ]+@[^@ ]+\.[^@ ]+$'; then
  log "WARNING: ADMIN_EMAIL '${ADMIN_EMAIL}' is not an e-mail address; using admin@example.com"
  ADMIN_EMAIL=admin@example.com
fi
export ADMIN_EMAIL
if ! printf '%s' "${ADMIN_PASSWORD:-}" | grep -Eq '^.{8,}$' || ! printf '%s' "${ADMIN_PASSWORD:-}" | grep -q '[A-Za-z]' || ! printf '%s' "${ADMIN_PASSWORD:-}" | grep -q '[0-9]'; then
  ADMIN_PASSWORD="Locked$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')9"
  log "WARNING: ADMIN_PASSWORD needs 8+ characters with a letter and a digit. If the admin is created now it gets a random password nobody knows; set a valid ADMIN_PASSWORD, reset the database (or the user) and redeploy."
fi
export ADMIN_PASSWORD

scripts/start.sh &
app=$!
trap 'kill -TERM "$app" 2>/dev/null' TERM INT
node /app/railway-bootstrap.mjs &
wait "$app"
