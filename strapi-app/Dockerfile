
FROM node:20-bullseye-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build



FROM node:20-bullseye-slim

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app /app

RUN npm prune --production

EXPOSE 1337

CMD ["npm", "run", "start"]
