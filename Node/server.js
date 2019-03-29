//Server for match making system

const WebSocketServer = require('ws').Server;
const localtunnel = require('localtunnel');
const port = 8092;
const wss = new WebSocketServer({ port: port });
					
let ids = []; //For priority queue
let players = {}; //Dictionary of players that retain socket IDS and socket objects

console.log("Starting server on port:", port);

// 'Assign random public DNS'
const tunnel = localtunnel(port, {subdomain: 'testing123'}, (err, tunnel) => {
    console.log('Connect to', tunnel.url);
});

wss.on('connection', function connection(ws) {

	//Player is searching for an opponent
	let on_connect = ws.protocol.split('!');
	let id = on_connect[0]; //Receive MAC address of connected player
	let name = on_connect[1]; //Name of player
	ids.unshift(id); 
	players[id] = {socket: ws, my_ID: name};
	console.log("Players in queue:", ids.length);

	//Player send message to server
	ws.on('message', function message(msg) {
		msg = "" + msg;
		if (msg == "Find Match") {
			while (ids.length >= 2) {
				let player_1_ID = ids.pop();
				let player_2_ID = ids.pop();
				try {
					players[player_1_ID].opponent_ID = player_2_ID;
					players[player_2_ID].opponent_ID = player_1_ID;
					let seed = Math.floor(Math.random() * 1000).toString();
					players[player_2_ID].socket.send('ID' + player_2_ID.toString() + ', OppID' + player_1_ID.toString() + ',' + seed);
					players[player_1_ID].socket.send('ID' + player_1_ID.toString() + ', OppID' + player_2_ID.toString() + ',' + seed);
					console.log(player_1_ID.toString(), "V.S", player_2_ID.toString());
				} catch (err) { //Put players back in queue in case of socket error
					console.log(err);					
					ids.unshift(player_2_ID);
					ids.unshift(player_1_ID);
				} 
			}
		}  // In game messaging i.e. opponent found a set
		else if (msg.startsWith("SET")) {
			msg = msg.split(",")
			let opp_id = parseInt(msg[1]);
			let set = msg[2] + "," + msg[3] + "," + msg[4];
			try {
				players[opp_id].socket.send("SET," + set);
				console.log("Set sent to Opp_ID:", opp_id.toString());
			} catch (err) {
				console.log("Attempt to send to disconnected opponent:", opp_id);
			}
		} 
		else if (msg == "PING") {
			//ensuring client stays alive in game
		}
		else { //Not a valid message sent to server -> close connection
			ws.close();
		}
	});

	//Player disconnected from server
	ws.on('close', function(data, flags) {
		//Inefficient way to remove disconnected player from queue
		for (const [id, player] of Object.entries(players)) {
			if (player.socket == ws) {
				try {
					console.log("Player ID:", player.opponent_ID, "has disconnected");
					players[player.opponent_ID].socket.send('WIN');
	     		} catch (err) {
	     			//
	     		}
	     		delete players[id];
				ids.splice(ids.indexOf(id), 1);
				break;
			}
		}

	});

});