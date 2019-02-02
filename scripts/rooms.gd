extends VBoxContainer
const udp_client_port = 56883
const udp_server_port = 56884
const MAX_ATTEMPTS = 100
var servers = []
var attempts = 0

func find_servers():
	var servers = []
	global.udp_sock = PacketPeerUDP.new()
	global.udp_sock.listen(udp_client_port)
	global.discovery_on = true
	if global.discovery_on:
		for addr in IP.get_local_addresses():
			var parts = addr.split('.')
			if parts.size() == 4:
				parts[3] = '255'
				global.udp_sock.set_dest_address(parts.join('.'), udp_server_port)
				global.udp_sock.put_var(global.get_host_ip())
				var server_ip = global.udp_sock.get_var()
				if server_ip != null and not(server_ip in servers):
					servers.append(server_ip)
					attempts = 0
			global.wait(0.1)
	global.udp_sock.close()
	return servers
	
func _pressed(server_ip):
	set_process(false)
	global.refresh_globals()
	global.server_ip = server_ip
	get_tree().change_scene("Lobby.tscn")
	
func _process(delta):
	var updated_servers = find_servers()
	if updated_servers.size() == 0:
		attempts += 1
		if attempts >= MAX_ATTEMPTS:
			for child in get_children():
				servers.erase(child.text)
				remove_child(child)
	for server_ip in updated_servers:
		if not(server_ip in updated_servers) and server_ip in servers:
			remove_child(server_ip)
		elif not(server_ip in servers):
			servers.append(server_ip)
			var server_button = Button.new()
			server_button.name = server_ip
			server_button.text = server_ip
			server_button.rect_min_size.y = 75
			server_button.connect("pressed", self, "_pressed", [server_ip])
			add_child(server_button)
		
func _ready():
	set_process(true)