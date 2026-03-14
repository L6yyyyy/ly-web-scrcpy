FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖（不含 npm 本地安装）
RUN apt update && apt install -y --no-install-recommends \
    adb \
    scrcpy \
    nodejs \
    && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# 直接用系统 node 运行，不依赖任何 npm 包
EXPOSE 8080
CMD ["node", "server.js"]
