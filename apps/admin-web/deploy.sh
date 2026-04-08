#!/bin/bash
# Zoea Admin — Kwezi production VPS (default root@209.74.80.195): rsync sources, then docker compose on server.
# Run from this directory:  cd apps/admin-web && ./deploy.sh
# Full deploy including remote rebuild:  ./deploy-kwezi.sh
#
# Prerequisites on server: Docker + Docker Compose plugin, directory /opt/zoea-admin

set -euo pipefail
cd "$(dirname "$0")"

SERVER="${DEPLOY_SERVER:-root@209.74.80.195}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/opt/zoea-admin}"

# Password SSH (sshpass): use ./deploy-admin.sh with DEPLOY_SERVER_PASSWORD — same host/dir/port.

echo "🚀 Zoea Admin deploy → ${SERVER}:${REMOTE_DIR} (host port 3015)"
echo ""

if ! command -v docker >/dev/null 2>&1; then
  echo "⚠️  docker not found locally — skip local build check"
else
  echo "📦 docker compose build (local verification, optional)..."
  if docker compose build; then
    echo "✅ Local build OK"
  else
    echo "⚠️  Local build skipped (daemon missing or build failed) — continuing with rsync"
  fi
fi

echo ""
echo "📤 rsync admin-web → server (excluding node_modules, .next, .git)..."
ssh -o BatchMode=yes -o ConnectTimeout=10 "$SERVER" "mkdir -p '$REMOTE_DIR'" || {
  echo "❌ SSH failed (need key: ssh $SERVER). Set DEPLOY_SERVER=user@host if different."
  exit 1
}

rsync -avz \
  --exclude node_modules \
  --exclude .next \
  --exclude .git \
  --exclude '.env' \
  --exclude '.env.local' \
  -e 'ssh -p 22' \
  ./ "$SERVER:$REMOTE_DIR/"

echo ""
echo "✅ Rsync done."
echo ""
echo "📋 On the server, run (first time copy .env):"
echo "    ssh $SERVER"
echo "    cd $REMOTE_DIR"
echo "    cp -n .env.example .env   # then: nano .env"
echo "    docker compose up -d --build"
echo ""
echo "    App: http://$(echo "$SERVER" | sed 's/.*@//'):3015"
echo ""
echo "Or one-liner:"
echo "    ssh $SERVER 'cd $REMOTE_DIR && test -f .env || cp .env.example .env; docker compose up -d --build'"
