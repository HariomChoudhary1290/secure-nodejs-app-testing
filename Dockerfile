FROM node:22-bookworm-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

USER appuser

EXPOSE 3000

CMD ["npm","start"]