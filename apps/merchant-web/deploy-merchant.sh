#!/bin/bash

# Zoea Merchant Web — password SSH deploy (same VPS pattern as apps/admin-web/deploy-admin.sh).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVER="${DEPLOY_SERVER:-root@209.74.80.195}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/opt/zoea-merchant}"
MERCHANT_PORT="${MERCHANT_PORT:-3016}"
NEXT_PUBLIC_API_URL="${NEXT_PUBLIC_API_URL:-https://zoea-africa.qtsoftwareltd.com/api}"

if [ -z "$DEPLOY_SERVER_PASSWORD" ]; then
    echo -e "${RED}Error: DEPLOY_SERVER_PASSWORD environment variable is not set${NC}"
    echo -e "${YELLOW}export DEPLOY_SERVER_PASSWORD='your-password'${NC}"
    exit 1
fi
SERVER_PASSWORD="$DEPLOY_SERVER_PASSWORD"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Zoea Merchant Web Deployment${NC}"
echo -e "${GREEN}========================================${NC}"

echo -e "${YELLOW}Checking connection to $SERVER...${NC}"
if ! sshpass -p "$SERVER_PASSWORD" ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o PreferredAuthentications=password "$SERVER" "echo 'Connected'" &> /dev/null; then
    echo -e "${RED}✗ Cannot connect to $SERVER${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connected to $SERVER${NC}"

echo -e "\n${YELLOW}Step 1: Creating deployment package...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

tar --exclude='node_modules' --exclude='.next' --exclude='dist' \
    --exclude='.git' --exclude='*.log' --exclude='.env*' \
    --exclude='deploy-*' --exclude='merchant-deploy.tar.gz' \
    -czf /tmp/merchant-deploy.tar.gz .

echo -e "\n${YELLOW}Step 2: Syncing to server...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password "$SERVER" "mkdir -p $REMOTE_DIR"
sshpass -p "$SERVER_PASSWORD" scp -o StrictHostKeyChecking=no -o PreferredAuthentications=password /tmp/merchant-deploy.tar.gz "$SERVER:/tmp/"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password "$SERVER" "cd $REMOTE_DIR && rm -rf * && tar xzf /tmp/merchant-deploy.tar.gz && rm /tmp/merchant-deploy.tar.gz"

sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password "$SERVER" <<EOF
cd $REMOTE_DIR
cat > .env <<ENVEOF
NODE_ENV=production
NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
ENVEOF
EOF

rm -f /tmp/merchant-deploy.tar.gz

echo -e "${GREEN}✓ Files synced to server${NC}"

echo -e "\n${YELLOW}Step 3: Deploying on server (Docker)...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password "$SERVER" bash -s <<REMOTE_SCRIPT
set -euo pipefail
cd "$REMOTE_DIR"

docker network create zoea-network 2>/dev/null || true

export MERCHANT_PORT="${MERCHANT_PORT:-3016}"

echo "Building Docker image..."
docker compose --env-file .env build

echo "Starting merchant web..."
docker compose --env-file .env up -d

for i in \$(seq 1 30); do
    if docker compose ps 2>/dev/null | grep -q healthy; then
        echo "✓ Merchant web is healthy"
        break
    fi
    echo "Waiting... (\$i/30)"
    sleep 2
done

docker compose ps
docker compose logs --tail=20
REMOTE_SCRIPT

SERVER_IP=$(echo "$SERVER" | cut -d'@' -f2)
sleep 5

echo -e "\n${YELLOW}Step 4: Health check...${NC}"
if curl -f -s "http://$SERVER_IP:$MERCHANT_PORT" > /dev/null; then
    echo -e "${GREEN}✓ Merchant web responds on http://$SERVER_IP:$MERCHANT_PORT${NC}"
else
    echo -e "${YELLOW}⚠ Not ready yet or firewall — check manually.${NC}"
fi

echo -e "\n${GREEN}Deployment finished.${NC}"
echo -e "URL: ${GREEN}http://$SERVER_IP:$MERCHANT_PORT${NC}"
echo -e "API (build-time): ${GREEN}$NEXT_PUBLIC_API_URL${NC}"
echo ""
echo "Reverse proxy: point merchant HOSTNAME → http://127.0.0.1:$MERCHANT_PORT (TLS at proxy)."
echo "Logs: ssh $SERVER 'cd $REMOTE_DIR && docker compose --env-file .env logs -f'"
