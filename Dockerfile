FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
COPY server/package*.json ./server/
COPY shared/package*.json ./shared/
RUN npm install
COPY shared/ ./shared/
COPY server/ ./server/
WORKDIR /app/server
RUN npm run build

FROM node:20-slim
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server/dist ./server/dist
COPY --from=builder /app/server/package*.json ./server/
ENV NODE_ENV=production
ENV PORT=3001
EXPOSE 3001
CMD ["node", "server/dist/index.js"]
