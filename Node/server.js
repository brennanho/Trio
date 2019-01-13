// Server for match making system

const http = require('http');
const localtunnel = require('localtunnel');
const express = require('express');
const socket = require('socket.io');

const port = 8092;
const server = http.createServer(express());

// 'Deploy webapp'
const tunnel = localtunnel(port, { subdomain: 'sdfdsfqgqgqerqezdczxcfeqfzxcv'}, (err, tunnel) => {
    console.log(tunnel.url);
});

// Initiate server
server.listen(port, () => console.log('Listening on port', port));

let io = socket(server);
let players = [];
io.on('connection', function(socket) {
    console.log('Client connected:', socket.id);
    players.unshift(socket.id);

 	console.log(players);
})

io.on('message', function(msg) {
	console.log(msg);
})