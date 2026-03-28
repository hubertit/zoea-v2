#!/usr/bin/env bash
#
# Deploy Zoea backend to primary (and optionally backup) servers.
#
# Authentication (pick one):
#   export DEPLOY_SSH_PASSWORD='your-ssh-password'
#   OR configure SSH keys: ssh-copy-id qt@172.16.40.61
#
# Optional:
#   PRIMARY_SERVER=qt@172.16.40.61
#   BACKUP_SERVER=qt@172.16.40.60
#   PRIMARY_ONLY=1          # skip backup server
#
# Default: same as DEPLOY_ASK_ZOEA.md — rsync excludes dist; the server runs
# `docker compose up --build` and builds inside Docker.
#
# If the server cannot reach npm / Alpine mirrors (DNS), build the image locally and load it:
#   LOCAL_DOCKER_BUILD=1 PRIMARY_ONLY=1 ./deploy-now.sh
# Requires Docker running locally; uses linux/amd64 for typical x86 servers.
#
set -euo pipefail

LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRIMARY_ONLY="${PRIMARY_ONLY:-0}"
LOCAL_DOCKER_BUILD="${LOCAL_DOCKER_BUILD:-0}"

# shellcheck source=scripts/deploy-ssh-lib.sh
source "$LOCAL_DIR/scripts/deploy-ssh-lib.sh"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  🚀 Zoea Backend Deployment             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

require_deploy_auth

echo -e "${YELLOW}📦 Step 1: Building backend locally...${NC}"
(cd "$LOCAL_DIR" && npm run build)
echo -e "${GREEN}✅ Build successful${NC}"
echo ""

echo -e "${YELLOW}📤 Step 2: Syncing to servers...${NC}"
deploy_ssh "$PRIMARY_SERVER" "mkdir -p $BACKEND_DIR" || true
echo -e "${YELLOW}🔧 Ensuring remote dist is writable (sudo, same password as SSH)...${NC}"
deploy_fix_remote_backend_dist "$PRIMARY_SERVER"

if [ "$PRIMARY_ONLY" = "1" ] || [ "$PRIMARY_ONLY" = "true" ]; then
  echo -e "${YELLOW}📤 PRIMARY_ONLY: syncing only to ${PRIMARY_SERVER}${NC}"
  deploy_rsync_to "$PRIMARY_SERVER" "$LOCAL_DIR" "$BACKEND_DIR"
else
  (cd "$LOCAL_DIR" && ./scripts/sync-all-environments.sh)
fi
echo ""

echo -e "${YELLOW}🔄 Step 3: docker compose on primary (${PRIMARY_SERVER})...${NC}"
if [ "$LOCAL_DOCKER_BUILD" = "1" ] || [ "$LOCAL_DOCKER_BUILD" = "true" ]; then
  command -v docker >/dev/null 2>&1 || {
    echo -e "${RED}❌ LOCAL_DOCKER_BUILD=1 requires Docker. Start Docker Desktop or install docker.${NC}"
    exit 1
  }
  docker info >/dev/null 2>&1 || {
    echo -e "${RED}❌ Docker daemon not running. Start Docker Desktop.${NC}"
    exit 1
  }
  echo -e "${YELLOW}Building zoea-api:latest locally (linux/amd64)...${NC}"
  docker build --platform linux/amd64 -t zoea-api:latest "$LOCAL_DIR"
  echo -e "${YELLOW}Saving and loading image on ${PRIMARY_SERVER}...${NC}"
  docker save zoea-api:latest | gzip -1 | {
    if [ -n "${DEPLOY_SSH_PASSWORD:-}" ]; then
      SSHPASS="$DEPLOY_SSH_PASSWORD" sshpass -e ssh -o StrictHostKeyChecking=accept-new "$PRIMARY_SERVER" 'gunzip -c | docker load'
    else
      ssh -o StrictHostKeyChecking=accept-new "$PRIMARY_SERVER" 'gunzip -c | docker load'
    fi
  }
  deploy_ssh "$PRIMARY_SERVER" bash -s <<REMOTE
set -e
cd ~/zoea-backend
echo "Starting containers (prebuilt image, no remote build)..."
if docker compose version >/dev/null 2>&1; then
  docker compose up -d --no-build
else
  # docker-compose 1.29 + OCI images: recreate hits KeyError 'ContainerConfig'
  docker ps -aq --filter name=zoea-api | xargs -r docker rm -f 2>/dev/null || true
  docker-compose up -d --no-build
fi
sleep 8
if docker compose version >/dev/null 2>&1; then
  docker compose ps
else
  docker-compose ps
fi
REMOTE
else
  deploy_ssh "$PRIMARY_SERVER" bash -s <<REMOTE
set -e
cd ~/zoea-backend
echo "Building and starting containers..."
if docker compose version >/dev/null 2>&1; then
  docker compose up -d --build
else
  docker ps -aq --filter name=zoea-api | xargs -r docker rm -f 2>/dev/null || true
  docker-compose up -d --build
fi
sleep 8
if docker compose version >/dev/null 2>&1; then
  docker compose ps
else
  docker-compose ps
fi
REMOTE
fi

echo -e "${GREEN}✅ Primary server deployed${NC}"
echo ""

if [ "$PRIMARY_ONLY" = "1" ] || [ "$PRIMARY_ONLY" = "true" ]; then
  echo -e "${YELLOW}⏭️  Skipping backup (PRIMARY_ONLY)${NC}"
else
  echo -e "${YELLOW}🔄 Step 4: docker compose on backup (${BACKUP_SERVER})...${NC}"
  COMPOSE_UP_EXTRA="--build"
  if [ "$LOCAL_DOCKER_BUILD" = "1" ] || [ "$LOCAL_DOCKER_BUILD" = "true" ]; then
    COMPOSE_UP_EXTRA="--no-build"
    echo -e "${YELLOW}Loading image on ${BACKUP_SERVER}...${NC}"
    docker save zoea-api:latest | gzip -1 | {
      if [ -n "${DEPLOY_SSH_PASSWORD:-}" ]; then
        SSHPASS="$DEPLOY_SSH_PASSWORD" sshpass -e ssh -o StrictHostKeyChecking=accept-new "$BACKUP_SERVER" 'gunzip -c | docker load'
      else
        ssh -o StrictHostKeyChecking=accept-new "$BACKUP_SERVER" 'gunzip -c | docker load'
      fi
    }
  fi
  deploy_ssh "$BACKUP_SERVER" bash -s <<REMOTE
set -e
cd ~/zoea-backend
if docker compose version >/dev/null 2>&1; then
  docker compose up -d ${COMPOSE_UP_EXTRA}
else
  docker ps -aq --filter name=zoea-api | xargs -r docker rm -f 2>/dev/null || true
  docker-compose up -d ${COMPOSE_UP_EXTRA}
fi
sleep 8
if docker compose version >/dev/null 2>&1; then
  docker compose ps
else
  docker-compose ps
fi
REMOTE
  echo -e "${GREEN}✅ Backup server deployed${NC}"
fi
echo ""

echo -e "${YELLOW}🔍 Step 5: Health check...${NC}"
HEALTH_CHECK=$(curl -sS -m 20 https://zoea-africa.qtsoftwareltd.com/api/health || true)
if echo "$HEALTH_CHECK" | grep -q "ok"; then
  echo -e "${GREEN}✅ API health OK${NC}"
  echo "Response: $HEALTH_CHECK"
else
  echo -e "${RED}❌ Health check did not return ok (network or API issue)${NC}"
fi
echo ""

echo -e "${YELLOW}📋 Step 6: Recent API logs (primary)...${NC}"
deploy_ssh "$PRIMARY_SERVER" bash -s <<'REMOTE' || true
cd ~/zoea-backend
if docker compose version >/dev/null 2>&1; then
  docker compose logs --tail=25 api 2>/dev/null | tail -20
else
  docker-compose logs --tail=25 api 2>/dev/null | tail -20
fi
REMOTE

echo ""
echo -e "${BLUE}✅ Deployment script finished.${NC}"
echo "API docs: https://zoea-africa.qtsoftwareltd.com/api/docs"
