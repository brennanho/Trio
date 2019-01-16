//Server for match making system
const WebSocketServer = require('ws').Server;
const localtunnel = require('localtunnel');
const port = 8092;
const wss = new WebSocketServer({ port: port });

//'Assign random public DNS'
const tunnel = localtunnel(port, {subdomain: 'testing12345'}, (err, tunnel) => {
    console.log(tunnel.url);
});

wss.on('connection', function connection(ws) {
	ws.send('Greetings from server');
	ws.on('message', function message(msg) {
		msg = "" + msg;
		console.log(""+ msg);
	});
});