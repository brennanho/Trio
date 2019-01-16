//Server for match making system

const WebSocketServer = require('ws').Server;
const localtunnel = require('localtunnel');
const port = 8092;
const wss = new WebSocketServer({ port: port });

let id = 0;
let ids = []; //For priority queue
let sockets = {}; //Maintain player sockets

//'Assign random public DNS'
const tunnel = localtunnel(port, {subdomain: 'testing123456'}, (err, tunnel) => {
    console.log('Connect to', tunnel.url);
});

wss.on('connection', function connection(ws) {
	
	//Player is searching for an opponent
	ids.unshift(id);
	sockets[id++] = ws;
	console.log("Players in queue:", Object.keys(sockets).length);

	//Player send message to server
	ws.on('message', function message(msg) {
		msg = "" + msg;
		if (msg == "Find Match") {
			while (ids.length >= 2) {
				try {
					let player_1_ID = ids.pop();
					let player_2_ID = ids.pop();
					console.log(Object.keys(sockets), player_1_ID, player_2_ID);
					sockets[player_1_ID].send('ID' + player_1_ID.toString() + ', OppID' + player_2_ID.toString());
					sockets[player_2_ID].send('ID' + player_2_ID.toString() + ', OppID' + player_1_ID.toString());
					delete sockets[player_1_ID];
					delete sockets[player_2_ID];
					console.log(player_1_ID.toString(), "V.S", player_2_ID.toString()); 
				} catch(err) {
					console.log(err);
				}
			}
		}
	});

	//Player disconnected from server
	ws.on('close', function(data, flags) {
		//Inefficient way to remove disconnected player from queue
		for (let id in sockets) {
			if (sockets[id] === ws) {
				console.log("Player ID:", id, "has disconnected");
				delete sockets[id];
				for( let i = 0; i < ids.length; i++){ 
   					if (ids[i] == id) {
     					ids.splice(i, 1);
     					break;
  					}
				}
				break;
			}
		}

	});

});