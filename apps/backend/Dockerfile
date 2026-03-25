FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies for Prisma
RUN apk add --no-cache openssl

# Ensure devDependencies are installed in builder stage.
# We need Nest CLI (devDep) for `npm run build`.
ENV NODE_ENV=development

# Builder stage dependencies.
# We keep this as default `npm ci` to avoid flaky npm behavior in the deploy environment.

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies (include devDependencies for Nest CLI)
RUN npm ci --include=dev --no-audit --no-fund

# Generate Prisma client if the Prisma CLI is available.
# Some deploy environments may not install devDependencies during Docker builds.
# Skipping generation when the CLI is missing keeps the build from failing; in
# many cases `@prisma/client` postinstall already generates the client.
RUN if [ -x ./node_modules/.bin/prisma ]; then ./node_modules/.bin/prisma generate; else echo "prisma CLI not found; skipping prisma generate"; fi

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl

# Copy built assets
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000

CMD ["node", "dist/main.js"]

