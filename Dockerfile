FROM alpine:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    adb \
    ffmpeg \
    python3 \
    py3-pip \
    make \
    g++

WORKDIR /app
COPY . .

RUN npm install
EXPOSE 8080
CMD ["npm", "start"]
