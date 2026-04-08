#!/bin/bash
# Deploy Zoea Admin to the Kwezi production VPS (same defaults as deploy.sh).
# Run from your machine with SSH access:  cd apps/admin-web && ./deploy-kwezi.sh
#
# Override if needed:  DEPLOY_SERVER=user@host DEPLOY_REMOTE_DIR=/path ./deploy-kwezi.sh

set -euo pipefail
cd "$(dirname "$0")"

export DEPLOY_SERVER="${DEPLOY_SERVER:-root@209.74.80.195}"
export DEPLOY_REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/opt/zoea-admin}"

./deploy.sh

echo ""
echo "🔧 Remote: docker compose up -d --build …"
ssh -o BatchMode=yes -o ConnectTimeout=15 "$DEPLOY_SERVER" \
  "cd '$DEPLOY_REMOTE_DIR' && test -f .env || cp .env.example .env && docker compose up -d --build"

HOST_IP="${DEPLOY_SERVER#*@}"
echo ""
echo "✅ Admin deploy finished — http://${HOST_IP}:3015 (or https://admin.zoea.africa if proxied)"
