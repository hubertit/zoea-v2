#!/bin/bash
# Gemura-style deploy: production build → stage files under dist/zoea-admin/
# (Same pattern as /Applications/AMPPS/www/gemura2/deploy.sh: build + copy artifacts.)
#
# Next.js uses the "standalone" output (needs Node on the host to run server.js).
# Put API URL in .env.production before building (Next loads it automatically).
#
# Usage: npm run deploy   (or ./deploy.cpanel.sh)

set -euo pipefail
cd "$(dirname "$0")"

OUT_DIR="dist/zoea-admin"

echo "🚀 Deploying Zoea Admin (Gemura-style)…"

if [ ! -f .env.production ]; then
  echo "📄 No .env.production — copying from .env.production.example"
  cp .env.production.example .env.production
fi

echo "📦 Building Next.js (production)…"
NODE_ENV=production npm run build

echo "✅ Build successful!"

echo "📁 Staging standalone bundle → ${OUT_DIR}/ …"
rm -rf dist
mkdir -p "${OUT_DIR}"

# Minimal runnable tree (see https://nextjs.org/docs/app/api-reference/config/next-config-js/output#standalone)
cp -R .next/standalone/. "${OUT_DIR}/"
mkdir -p "${OUT_DIR}/.next"
cp -R .next/static "${OUT_DIR}/.next/static"

# Ensure public assets exist at server root (standalone usually already includes public/)
if [ -d public ] && [ -n "$(ls -A public 2>/dev/null)" ]; then
  mkdir -p "${OUT_DIR}/public"
  cp -R public/. "${OUT_DIR}/public/"
fi

echo "✅ Deployment files ready in ${OUT_DIR}/"
echo ""
echo "📋 Next steps (pick one):"
echo "   • VPS / Node host: upload ${OUT_DIR}/ contents, then:"
echo "       cd /path/to/app && NODE_ENV=production PORT=3015 node server.js"
echo "   • cPanel: only if your plan supports a Node.js application — point it at this folder and server.js."
echo "   • Docker + rsync to a VPS: npm run deploy:docker"
echo ""
