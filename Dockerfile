FROM node:22-bookworm-slim

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
 CMD node -e "require('http').get('http://localhost:3000', (res) => process.exit(res.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["npm","start"]