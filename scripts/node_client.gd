extends Button
var ws = WebSocketClient.new()
var wss = WebSocketServer.new()
var wsp = WebSocketPeer.new()
var socket_id 
var opp_socket_id
const server_url = "ws://testing123456.localtunnel.me/socket.io/?EIO=3&transport=websocket"
const localhost = "ws://127.0.0.1:8092/socket.io/?EIO=3&transport=websocket"
	
#Websocket signals 
func _connection_established(protocol):
	var msg = "Find Match".to_utf8()
	print(ws.get_peer(1).put_packet(msg))
func _connection_closed(reason):
	print("Connection closed:", reason)
	ws.get_peer(1).put_packet("ID: " + socket_id + "has disconnected")
func _connection_error():
	print("Could not connect to server")
	
func _data_received():
	var msg = ws.get_peer(1).get_packet().get_string_from_utf8()
	print(msg)
	if msg.begins_with("ID"):
		msg = msg.split(",")
		socket_id = msg[0].substr(2,len(msg[0]))
		opp_socket_id = msg[1].substr(6, len(msg[1]))
		print("My ID: ", socket_id)
		print("Opp ID: ", opp_socket_id)
	
func _process(delta):
	if ws.CONNECTION_CONNECTED:
		ws.poll()
		
func _on_Find_Opponent_button_down():
	set_process(true)
	while ws.connect_to_url(server_url, PoolStringArray(['hello']), false) != 0:
		print("Attempting to connect to server...")
	self.disabled = true
	
#Initialize websocket signals
func _ready():
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	ws.connect("data_received", self, "_data_received")
	set_process(false)
