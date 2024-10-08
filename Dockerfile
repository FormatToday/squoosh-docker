# 使用 Node.js 作为基础镜像
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /app

# 克隆 Squoosh 项目代码
RUN apk add --no-cache git && \
    git clone https://github.com/GoogleChromeLabs/squoosh.git /app && \
    cd /app

# 安装项目依赖
RUN npm install

# 构建 Squoosh 项目
RUN npm run build

# 使用 Nginx 作为 Web 服务器，提供静态文件服务
FROM nginx:alpine

# 将构建好的静态文件拷贝到 Nginx 容器
COPY --from=build /app/build/ /usr/share/nginx/html

# 暴露 Nginx 默认的 HTTP 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
