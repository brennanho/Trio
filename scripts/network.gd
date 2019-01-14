extends Node
const int_port = 56885
const ext_port = 56885

# EXECUTED ON CLIENT SIDE
remote func update_players_lobby(players, id):
	global.players_in_lobby = players
	global.my_name = id
	get_parent().add_players_to_screen(global.players_in_lobby)
	
remote func add_new_client_to_other_client(id):
	get_parent().add_player_to_screen(id)
	
remote func remove_client_from_other_client(id):
	get_parent().remove_player_from_screen(id)

func _connected_to_server(id):
	print('Client ' + str(id) + ' connected to Server')

func _connect_to_server_fail():
	print('Client failed to connect to Server')

func _connect_to_server_success():
	print('Client connected to Server')

func _disconnected_from_server(id):
	print('Client' + str(id) + ' disconnected from Server')
	get_tree().change_scene(global.prev_scene)
	global.refresh_globals()

# EXECUTED ON SERVER SIDE
func _client_connected(id):
	print('Client ' + str(id) + ' has joined')
	get_parent().add_player_to_screen(id)
	var i = 2
	for player_id in global.players_in_lobby.keys():
		if player_id != 1 and player_id != id:
			rpc_id(player_id, "add_new_client_to_other_client", id)
			i += 1
	rpc_id(id, "update_players_lobby", global.players_in_lobby, id)

func _client_disconnected(id):
	print('Client ' + str(id) + ' has left')
	for player_id in global.players_in_lobby.keys():
		if player_id != 1 and player_id != id:
			rpc_id(player_id, "remove_client_from_other_client", id)
	get_parent().remove_player_from_screen(id)
	
func init_port_mapping():
	var upnp = UPNP.new()
	print(upnp.discover())
	print(upnp.query_external_address())
	upnp.set_discover_local_port(int_port)
	var router = upnp.get_gateway()
	router.set_igd_our_addr(global.get_host_ip())
	if router.add_port_mapping(ext_port, int_port, "", "TCP", 0) == upnp.UPNP_RESULT_SUCCESS:
		print("Port mapping success")
		return upnp
		
#func init_websocket_client(ip):
#	global.peer  = WebSocketClient.new()
#	var url = "ws://" + ip + ":" + str(int_port)
#	print(url)
#	print(global.peer.connect_to_url(url, PoolStringArray(['TCP']),true))
#	global.peer.connect('connection_established', self, '_connection_established')
#	global.peer.connect('connection_error', self, '_connection_error')
#	while global.peer.get_connection_status() == 1:
#		global.peer.poll()
#	return global.peer
#
#func init_websocket_server():
#	global.peer = WebSocketServer.new()
#	print(global.peer.listen(int_port, PoolStringArray(['TCP']), true))
#	print(global.peer.get_peer_address(1))
#	global.peer.connect("client_connected", self, "_client_connected")
#	return global.peer
	
func init_server():
	#global.upnp = init_port_mapping()
	global.peer = NetworkedMultiplayerENet.new()	
	global.server_ip = global.get_host_ip()
	global.peer.create_server(int_port, 5)
	global.my_name = 1
	global.peer.set_always_ordered(true)
	global.peer.transfer_mode = global.peer.TRANSFER_MODE_RELIABLE
	get_tree().set_network_peer(global.peer)
	get_tree().connect("network_peer_connected",    self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	return global.peer
	#return init_websocket_server()

func init_client(ip):
	#global.upnp = init_port_mapping()
	global.peer = NetworkedMultiplayerENet.new()
	global.peer.create_client(ip, int_port, 0, 0, 0)
	global.peer.set_always_ordered(true) 
	global.peer.transfer_mode = global.peer.TRANSFER_MODE_RELIABLE
	#while peer.get_connection_status() == 1:
		#peer.poll()
	get_tree().set_network_peer(global.peer)
	get_tree().connect("connected_to_server",  self,  "_connected_to_server", [global.peer.get_unique_id()])
	get_tree().connect("connection_failed",    self,  "_connect_to_server_fail")
	#get_tree().connect("connection_succeeded", self,  "_connect_to_server_success")
	get_tree().connect("server_disconnected",  self,  "_disconnected_from_server", [ip])
	return global.peer
	#return init_websocket_client(ip)