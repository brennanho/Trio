const io = require('socket.io-client');
const socket = io('https://testing12345.localtunnel.me');

socket.on('message', function(msg) {
    console.log(msg);
})

socket.emit('message', 'Hello from client');

socket.close()