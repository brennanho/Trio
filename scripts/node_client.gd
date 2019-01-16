extends Button
var ws = WebSocketClient.new()
var wss = WebSocketServer.new()
var wsp = WebSocketPeer.new()
const server_url = "ws://testing12345.localtunnel.me/socket.io/?EIO=3&transport=websocket"
const local_url = "ws://127.0.0.1:8092/socket.io/?EIO=3&transport=websocket"
	
#Websocket signals 
func _connection_established(protocol):
	print("Connection established with protocol: ", protocol)
func _connection_closed(reason):
	print("Connection closed:", reason)
func _connection_error():
	print("Connection error")
func _data_received():
	var msg = ws.get_peer(1).get_packet().get_string_from_utf8()
	print(msg)
	
func _process(delta):
	if ws.CONNECTION_CONNECTED:
		ws.poll()
		
func _on_Find_Opponent_button_down():
	if ws.CONNECTION_CONNECTED:
		var msg = "Hello from Godot".to_utf8()
		ws.get_peer(1).put_packet(msg)
	
#Initialize websocket signals
func _ready():
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	ws.connect("data_received", self, "_data_received")
	ws.connect_to_url(server_url, PoolStringArray([]), false)
	set_process(true)
