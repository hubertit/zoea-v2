#!/usr/bin/env bash
# Sync backend tree to primary + backup servers (no docker).
# See scripts/deploy-ssh-lib.sh for DEPLOY_SSH_PASSWORD / SSH keys.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=deploy-ssh-lib.sh
source "$SCRIPT_DIR/deploy-ssh-lib.sh"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔄 Syncing Zoea backend to primary + backup"
echo "============================================="
echo ""

require_deploy_auth

sync_one() {
  local server="$1"
  local name="$2"
  echo -e "${YELLOW}📤 Syncing to ${name} (${server})...${NC}"
  deploy_ssh "$server" "mkdir -p $BACKEND_DIR" || true
  deploy_fix_remote_backend_dist "$server"
  deploy_rsync_to "$server" "$BACKEND_ROOT" "$BACKEND_DIR"
  echo -e "${GREEN}✅ ${name} synced${NC}"
}

sync_one "$PRIMARY_SERVER" "Primary"
sync_one "$BACKUP_SERVER" "Backup"

echo ""
echo -e "${GREEN}✅ All targets synced.${NC}"
echo "Next on each host: cd ~/zoea-backend && docker compose up -d --build"
