extends Button
const server_url = "ws://testing123456.localtunnel.me/socket.io/?EIO=3&transport=websocket"
const localhost = "ws://127.0.0.1:8092/socket.io/?EIO=3&transport=websocket"

#Websocket signals
func _connection_established(protocol):
	var msg = "Find Match".to_utf8()
	print(global.ws.get_peer(1).put_packet(msg))
func _connection_closed(reason):
	print("Connection closed:", reason)
	if global.socket_id != null:
		global.ws.get_peer(1).put_packet("ID: " + global.socket_id + "has disconnected")
	else:
		global.ws.get_peer(1).put_packet("ID: UNKNOWN has disconnected")
func _connection_error():
	print("Could not connect to server")

func _data_received():
	var msg = global.ws.get_peer(1).get_packet().get_string_from_utf8()
	print(msg)
	if msg.begins_with("ID"):
		msg = msg.split(",")
		print(msg)
		global.socket_id = int(msg[0].substr(2,len(msg[0])))
		global.opp_socket_id = int(msg[1].substr(6, len(msg[1])))
		global.seed_val = int(msg[2])
		global.game_mode = "remote"
		print("My ID: ", global.socket_id)
		print("Opp ID: ", global.opp_socket_id)
		print("Seed: ", global.seed_val)
		global.players_score[global.socket_id] = 0
		global.players_score[global.opp_socket_id] = 0
		global.my_name = global.socket_id
		get_tree().change_scene("Start_Game.tscn")
	elif msg.begins_with("SET"):
		msg = msg.split(",")
		var card_1 = msg[1]
		var card_2 = msg[2]
		var card_3 = msg[3]
		print("Opponent has found a set: ", card_1, card_2, card_3)

func _on_Find_Opponent_button_down():
	self.disabled = true
	set_process(true)
	while global.ws.connect_to_url(server_url, PoolStringArray(['Find Opponent']), false) != 0:
		print("Attempting to connect to server...")

func _process(delta):
	global.ws.poll()

#Initialize websocket signals
func _ready():
	global.ws = WebSocketClient.new()
	global.ws.connect("connection_established", self, "_connection_established")
	global.ws.connect("connection_closed", self, "_connection_closed")
	global.ws.connect("connection_error", self, "_connection_error")
	global.ws.connect("data_received", self, "_data_received")
	set_process(false)
