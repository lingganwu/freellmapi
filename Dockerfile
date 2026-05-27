# 阶段 1: 构建前端和后端
FROM node:20-slim AS builder
WORKDIR /app

# 复制依赖定义
COPY package*.json ./
COPY server/package*.json ./server/
COPY shared/package*.json ./shared/
COPY client/package*.json ./client/

# 安装所有依赖
RUN npm install

# 复制源代码
COPY shared/ ./shared/
COPY server/ ./server/
COPY client/ ./client/

# 构建前端 (这会生成 /app/client/dist)
WORKDIR /app/client
RUN npm run build

# 构建后端
WORKDIR /app/server
RUN npm run build

# 阶段 2: 最终运行镜像
FROM node:20-slim
WORKDIR /app

# 复制生产环境 node_modules
COPY --from=builder /app/node_modules ./node_modules

# 复制构建后的后端代码
COPY --from=builder /app/server/dist ./server/dist
COPY --from=builder /app/server/package*.json ./server/

# 关键修正：复制构建后的前端静态文件到后端能找到的位置
# 根据你的报错，后端在找 /app/client/dist，所以我们保持这个结构
COPY --from=builder /app/client/dist ./client/dist

ENV NODE_ENV=production
ENV PORT=3001
EXPOSE 3001

CMD ["node", "server/dist/index.js"]
