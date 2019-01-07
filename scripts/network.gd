extends Node

func get_host_ip():
	var ips = []
	var bad_ips = ['169.254', '127.0.0.1', '0:0'] 
	for ip in IP.get_local_addresses():
		if len(ip) <= 15:
			var ip_ok = true
			for bad_ip in bad_ips:
				if ip.begins_with(bad_ip):
					ip_ok = false
					break
			if ip_ok:
				ips.append(ip)
	return ips[-1]
 
# EXECUTED ON CLIENT SIDE
remote func update_players_lobby(players):
	global.players = players
	global.my_name = str(players.size())
	get_parent().add_players_to_screen(global.players)

func _connected_to_server(id):
	print('Client ' + str(id) + ' connected to Server')

func _connect_to_server_fail(id):
	print('Client' + str(id) + ' failed to connect to Server')

func _disconnected_from_server(id):
	print('Client' + str(id) + ' disconnected from Server')

# EXECUTED ON SERVER SIDE
func _client_connected(id):
	print('Client ' + str(id) + ' has joined')
	get_parent().add_player_to_screen(str(global.players.size()+1))
	rpc("update_players_lobby", global.players)

func _client_disconnected(id):
	print('Client ' + str(id) + ' has joined')
	
	
func init_server():
	var peer = NetworkedMultiplayerENet.new()	
	global.server_ip = get_host_ip()
	peer.create_server(8888, 5)
	peer.set_bind_ip(global.server_ip)
	peer.transfer_mode = peer.TRANSFER_MODE_RELIABLE
	get_tree().set_network_peer(peer)
	get_tree().connect("network_peer_connected",    self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	return peer

func init_client(ip):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, 8888)
	peer.transfer_mode = peer.TRANSFER_MODE_RELIABLE
	get_tree().set_network_peer(peer)
	get_tree().connect("connected_to_server",self,"_connected_to_server", [peer.get_unique_id()])
	get_tree().connect("connection_failed",self,"_connect_to_server_fail")
	get_tree().connect("server_disconnected",self,"_disconnected_from_server")
	global.peer = peer
	return peer