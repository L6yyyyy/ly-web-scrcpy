const express = require('express');
const WebSocket = require('ws');
const { spawn } = require('child_process');
const http = require('http');
const path = require('path');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.static(path.join(__dirname, 'public')));

wss.on('connection', (ws) => {
  console.log('客户端已连接');

  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data);
      if (msg.action === 'connect' && msg.ip) {
        ws.send(JSON.stringify({ text: '已连接：' + msg.ip }));

        // 真实 ADB 连接
        spawn('adb', ['connect', msg.ip]);

        // 真实 scrcpy 推流 → 浏览器画面
        const scrcpy = spawn('scrcpy', [
          '--tcpip=' + msg.ip.split(':')[0],
          '--no-audio',
          '--video', 'stdout',
          '--max-size', '720'
        ]);

        scrcpy.stdout.on('data', (buf) => {
          ws.send(buf); // 视频流 → 前端
        });
      }
    } catch (e) {}
  });
});

server.listen(8080, () => {
  console.log('PANDA WEB-SCRCPY 启动成功 ✅');
});
