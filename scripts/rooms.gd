extends VBoxContainer
const udp_client_port = 56883
const udp_server_port = 56884
const MAX_ATTEMPTS = 150
var servers = {}

class Server:
	var button
	var attempts
	var ip
	func _init(button, attempts, ip):
		self.button = button
		self.attempts = attempts
		self.ip = ip

func find_servers():
	var updated_servers = {}
	global.udp_sock = PacketPeerUDP.new()
	global.udp_sock.listen(udp_client_port)
	global.discovery_on = true
	if global.discovery_on:
		var addresses = IP.get_local_addresses()
		addresses.append("255.255.255.255")
		for addr in addresses:
			var parts = addr.split('.')
			if parts.size() == 4:
				parts[3] = '255'
				global.udp_sock.set_dest_address(parts.join('.'), udp_server_port)
				global.udp_sock.put_var(global.get_host_ip())
				var server_ip = global.udp_sock.get_var()
				if server_ip != null:
					var server_ip_split = PoolStringArray(server_ip.split(".")).join("")
					if not(server_ip in updated_servers):
						updated_servers[server_ip] = server_ip_split
			global.wait(0.1)
	global.udp_sock.close()
	return updated_servers
	
func _pressed(server_ip):
	set_process(false)
	global.refresh_globals()
	global.server_ip = server_ip
	Transition.fade_to("Lobby.tscn")
	
func _process(delta):
	var updated_servers = find_servers()
	for server in servers.values():
		if not(server.ip in updated_servers.values()) and server.attempts >= MAX_ATTEMPTS:
			remove_child(server.button)
			servers.erase(server.ip)
		else:
			server.attempts += 1
	for server_ip in updated_servers.keys():
		if not(server_ip in servers.keys()):
			var server_button = TextureButton.new()
			var label = Label.new()
			var font = DynamicFont.new()
			font.size = 40
			font.font_data = load("res://fonts/Robi-Regular.ttf")
			label.add_font_override("font", font)
			label.add_color_override("font_color", Color(0,0,0))
			label.text = server_ip
			label.margin_left = get_parent().rect_size.x/3.5
			label.margin_top = 30
			server_button.name = server_ip
			server_button.mouse_filter = server_button.MOUSE_FILTER_PASS
			server_button.connect("pressed", self, "_pressed", [server_ip])
			server_button.texture_normal = load("res://Menu_Sprites/BLANK_OFF.png")
			server_button.texture_pressed = load("res://Menu_Sprites/BLANK_ON.png")
			server_button.expand = true
			server_button.stretch_mode = server_button.STRETCH_SCALE
			server_button.rect_min_size.x = get_parent().rect_size.x
			server_button.rect_min_size.y = get_parent().rect_size.y/7
			var server = Server.new(server_button, 0, server_ip)
			servers[server_ip] = server
			server_button.add_child(label)
			add_child(server_button)
		
func _ready():
	rect_min_size.x = get_parent().rect_size.x
	rect_min_size.y = get_parent().rect_size.y
	set_process(true)