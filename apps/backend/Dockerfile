FROM node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache openssl

# DevDependencies needed for Nest CLI (`npm run build`).
ENV NODE_ENV=development

COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci --include=dev --no-audit --no-fund

RUN if [ -x ./node_modules/.bin/prisma ]; then ./node_modules/.bin/prisma generate; else echo "prisma CLI not found; skipping prisma generate"; fi

COPY . .

RUN npm run build

FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

RUN apk add --no-cache openssl

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000

CMD ["node", "dist/main.js"]
