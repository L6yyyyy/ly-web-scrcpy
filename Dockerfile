FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y adb scrcpy nodejs npm
WORKDIR /app
COPY . .
RUN npm install express ws
EXPOSE 8080
CMD ["node","server.js"]
