extends Container
var ws = WebSocketClient.new()
	
func _connection_established(protocol):
	print("Connection established with protocol: ", protocol)
	
func _connection_closed():
	print("Connection closed")

func _connection_error():
	print("Connection error")

func _data_received():
	print("packet: ", ws.get_peer(1).get_packet().get_string_from_utf8())
	ws.get_peer(1).put_packet(PoolByteArray(['{"type": "event", "name": "message", "args": ["hello"]}']))
	ws.get_peer(1).put_var('{"type": "event", "name": "message", "args": ["hello"]}')
	
#func _process(delta):
#	ws.poll()
#
#func _ready():
#	ws.connect("connection_established", self, "_connection_established")
#	ws.connect("connection_closed", self, "_connection_closed")
#	ws.connect("connection_error", self, "_connection_error")
#	ws.connect("data_received", self, "_data_received")
#
#	var url = "ws://sdfdsfqgqgqerqezdczxcfeqfzxcv.localtunnel.me/socket.io/?EIO=3&transport=websocket"
#	print("Connecting to " + url + "...")
#	ws.connect_to_url(url, PoolStringArray(['set_godot']), false)