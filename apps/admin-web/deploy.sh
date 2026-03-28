#!/bin/bash
# Zoea Admin — same flow as Kwezi: rsync sources to server, then docker compose.
# Run from this directory:  cd apps/admin-web && ./deploy.sh
#
# Prerequisites on server: Docker + Docker Compose plugin, directory /opt/zoea-admin

set -euo pipefail
cd "$(dirname "$0")"

SERVER="${DEPLOY_SERVER:-root@209.74.80.195}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/opt/zoea-admin}"

echo "🚀 Zoea Admin deploy → ${SERVER}:${REMOTE_DIR} (host port 3015)"
echo ""

if ! command -v docker >/dev/null 2>&1; then
  echo "⚠️  docker not found locally — skip local build check"
else
  echo "📦 docker compose build (local verification, optional)..."
  docker compose build
  echo "✅ Local build OK"
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
