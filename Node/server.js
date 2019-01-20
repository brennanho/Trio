//Server for match making system

const WebSocketServer = require('ws').Server;
const localtunnel = require('localtunnel');
const port = 8092;
const wss = new WebSocketServer({ port: port });

let id = 0;					
let ids = []; //For priority queue
let sockets = {}; //Maintain player sockets

console.log("Starting server on port:", port);

// 'Assign random public DNS'
const tunnel = localtunnel(port, {subdomain: 'testing123456'}, (err, tunnel) => {
    console.log('Connect to', tunnel.url);
});

wss.on('connection', function connection(ws) {

	//Player is searching for an opponent
	ids.unshift(id);
	sockets[id++] = ws;
	console.log("Players in queue:", ids.length);

	//Player send message to server
	ws.on('message', function message(msg) {
		msg = "" + msg;
		//console.log(msg);
		if (msg == "Find Match") {
			while (ids.length >= 2) {
				let player_1_ID = ids.pop();
				let player_2_ID = ids.pop();
				let seed = Math.floor(Math.random() * 1000).toString();
				sockets[player_1_ID].send('ID' + player_1_ID.toString() + ', OppID' + player_2_ID.toString() + ',' + seed);
				sockets[player_2_ID].send('ID' + player_2_ID.toString() + ', OppID' + player_1_ID.toString() + ',' + seed);
				console.log(player_1_ID.toString(), "V.S", player_2_ID.toString()); 
			}
		}  // In game messaging i.e. opponent found a set
		else if (msg.startsWith("SET")) {
			msg = msg.split(",")
			let opp_id = parseInt(msg[1]);
			let set = msg[2] + "," + msg[3] + "," + msg[4];
			sockets[opp_id].send("SET," + set);
			console.log("Set sent to Opp_ID:", opp_id.toString());
		} 
		else if (msg == "PING") {
			//pass
		}
		else { //Not a valid message sent to server -> close connection
			ws.close();
		}
	});

	//Player disconnected from server
	ws.on('close', function(data, flags) {
		//Inefficient way to remove disconnected player from queue
		for (let id in sockets) {
			if (sockets[id] === ws) {
				console.log("Player ID:", id, "has disconnected");
				delete sockets[id];
     			ids.splice(ids.indexOf(id), 1);
     			break;
			}
		}

	});

});