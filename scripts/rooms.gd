
extends VBoxContainer

#CONSTANTS
const udp_client_port = 56883
const udp_server_port = 56884
const MAX_ATTEMPTS = 150
const BROADCAST_ADDR = "255.255.255.255"
const BUTTON_MARGIN_TOP = 30
const FONT_SIZE = 40
const OUTLINE_SIZE = 3
const ROOM_NAME_Y_OFFSET = 10
const FONT_PATH = "res://fonts/Robi-Regular.ttf"
const BLANK_ON_PATH = "res://Menu_Sprites/MENU_PROTOTYPE 2_ Playhouse/BLANKIE_ON.png"
const BLANK_OFF_PATH = "res://Menu_Sprites/MENU_PROTOTYPE 2_ Playhouse/BLANKIE_OFF.png"
const BLACK = Color(0,0,0)
const WHITE = Color(255,255,255)

#VARS
var servers = {}
onready var FONT = load(FONT_PATH)
onready var BLANK_OFF = load(BLANK_OFF_PATH)
onready var BLANK_ON = load(BLANK_ON_PATH)

class Server:
	var button
	var attempts
	var name
	func _init(button, attempts, name):
		self.button = button
		self.attempts = attempts
		self.name = name

func find_servers():
	var updated_servers = {}
	var my_ip = global.get_host_ip()
	if global.udp_sock == null:
		global.udp_sock = PacketPeerUDP.new()
	global.udp_sock.listen(udp_client_port)
	global.discovery_on = true
	if global.discovery_on:
		var addresses = IP.get_local_addresses()
		addresses.append(BROADCAST_ADDR)
		for addr in addresses:
			var parts = addr.split('.')
			if parts.size() == 4:
				parts[3] = '255'
				global.udp_sock.set_dest_address(parts.join('.'), udp_server_port)
				global.udp_sock.put_var(my_ip)
				var server = global.udp_sock.get_var()
				if server != null:
					var ip = server[0]
					var name = server[1]
					#if not(server in updated_servers):
					updated_servers[ip] = name 
	global.udp_sock.close()
	return updated_servers
	
func _pressed(server_ip, name):
	set_process(false)
	global.refresh_globals()
	global.server_ip = server_ip
	global.server_name = name
	Transition.fade_to(global.LOBBY_SCENE)
	
func _process(delta):
	var updated_servers = find_servers()
	for server in servers.values():
		if not(server.name in updated_servers.values()) and server.attempts >= MAX_ATTEMPTS:
			remove_child(server.button)
			servers.erase(server.name)
		else:
			server.attempts += 1
	for server_ip in updated_servers.keys():
		if not(server_ip in servers.keys()):
			var server_button = TextureButton.new()
			var label = Label.new()
			var font = DynamicFont.new()
			font.size = FONT_SIZE
			font.font_data = FONT
			font.outline_color = BLACK
			font.outline_size = OUTLINE_SIZE
			label.add_font_override("font", font)
			#label.add_color_override("font_color", BLACK)
			server_button.name = server_ip
			server_button.mouse_filter = server_button.MOUSE_FILTER_PASS
			server_button.connect("pressed", self, "_pressed", [server_ip, updated_servers[server_ip]])
			server_button.texture_normal = BLANK_OFF
			server_button.texture_pressed = BLANK_ON
			server_button.expand = true
			server_button.stretch_mode = server_button.STRETCH_SCALE
			server_button.rect_size.x = get_parent().rect_size.x
			server_button.rect_size.y = get_parent().rect_size.y/7
			server_button.rect_min_size.x = get_parent().rect_size.x
			server_button.rect_min_size.y = get_parent().rect_size.y/7
			var server = Server.new(server_button, 0, server_ip)
			servers[server_ip] = server
			server_button.add_child(label)
			label.valign = label.VALIGN_CENTER
			label.align = label.ALIGN_CENTER
			label.rect_position.y -= ROOM_NAME_Y_OFFSET
			label.rect_size = server_button.rect_size
			label.text = str(updated_servers[server_ip])
			add_child(server_button)
		
func _ready():
	rect_min_size.x = get_parent().rect_size.x
	rect_min_size.y = get_parent().rect_size.y
	global.prev_scene = global.MULTIPLAYER_SCENE
	set_process(true)