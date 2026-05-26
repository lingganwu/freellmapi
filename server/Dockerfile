# 使用 Node.js 官方镜像作为基础
FROM node:20-slim AS builder

WORKDIR /app

# 复制根目录的 package.json 和 lock 文件（因为是 monorepo）
COPY package*.json ./
COPY server/package*.json ./server/
COPY shared/ ./shared/

# 安装依赖
RUN npm install

# 复制服务器代码并编译
COPY server/ ./server/
RUN cd server && npm run build

# 运行阶段
FROM node:20-slim
WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/server/package*.json ./server/
COPY --from=builder /app/server/dist ./server/dist
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3001

CMD ["node", "server/dist/index.js"]
