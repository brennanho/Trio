extends Button
const SERVER_URL = "ws://testing123.localtunnel.me/socket.io/?EIO=3&transport=websocket"
const LOCALHOST = "ws://127.0.0.1:8092/socket.io/?EIO=3&transport=websocket"

#Websocket signals
func _connection_established(protocol):
	var msg = "Find Match".to_utf8()
	print(global.ws.get_peer(1).put_packet(msg))
func _connection_closed(reason):
	print("Connection closed:", reason)
	if global.socket_id != null:
		global.ws.get_peer(1).put_packet("ID: " + global.socket_id + "has disconnected")
	else:
		global.ws.get_peer(1).put_packet("ID: UNKNOWN has disconnected".to_utf8())
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
		global.game_mode = global.REMOTE_GAME
		print("My ID: ", global.socket_id)
		print("Opp ID: ", global.opp_socket_id)
		print("Seed: ", global.seed_val)
		global.players_score[global.socket_id] = 0
		global.players_score[global.opp_socket_id] = 0
		global.players_ips[global.socket_id] = global.socket_id
		global.players_ips[global.opp_socket_id] = global.opp_socket_id
		global.my_name = global.socket_id
		Transition.fade_to(global.GAME_SCENE)

func _on_Find_Opponent_button_down():
	self.disabled = true
	print(OS.get_unique_id())
	while global.ws.connect_to_url(SERVER_URL, PoolStringArray([OS.get_unique_id().replace("{","").replace("}","") + "!" + global.load_data('name')]), false) != 0:
		print("Attempting to connect to server...")
	set_process(true)

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
