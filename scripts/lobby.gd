extends VBoxContainer
const FONT_SIZE = 45
const BLACK = Color(0,0,0)
const RED = Color(1,0,0)
const FONT_PATH = "res://fonts/Robi-Regular.ttf"

onready var FONT = load(FONT_PATH)

sync func start_game(scene_to_load, seed_val, peer):
	if peer.get_unique_id() == 1: #peer is server
		global.discovery_on = false
		global.discover_thread.wait_to_finish()
		peer.refuse_new_connections = true
		global.udp_sock.close()
	
	global.seed_val = seed_val
	global.prev_scene = get_tree().current_scene
	Transition.fade_to(scene_to_load + ".tscn")

func _button_pressed(scene_to_load, seed_val, peer):
	rpc("start_game", scene_to_load, seed_val, peer)

func add_players_to_screen(players):
	for player in global.players_in_lobby.keys():
		add_player_to_screen(player, global.players_ips[player])
		
func add_player_to_screen(player_id, ip):
	var player = Label.new()
	player.text = global.ip_to_name(ip)
	var font = DynamicFont.new()
	font.size = FONT_SIZE
	font.font_data = FONT
	player.add_font_override("font", font)
	player.add_color_override("font_color", BLACK)
	if str(player_id) == str(global.my_name):
		player.add_color_override("font_color", RED)
	player.align = ALIGN_CENTER
	player.valign = VALIGN_CENTER
	add_child(player)
	global.players_in_lobby[player_id] = player
	global.players_score[player_id] = 0
	global.players_ips[player_id] = ip
	
func remove_player_from_screen(player_id):
	remove_child(global.players_in_lobby[player_id])
	global.players_in_lobby.erase(player_id)
	global.players_score.erase(player_id)

func _ready():
	var seed_val
	global.game_mode = global.LOCAL_GAME
	if global.network_role == global.ENET_SERVER:
		get_node("Network").init_server()
		randomize()
		seed_val = randi()
		add_player_to_screen(1, global.get_host_ip())
		global.discover_thread = Thread.new()
		global.discover_thread.start(get_node("Network"), "broadcast_to_clients", [null])
	else:
		get_parent().get_node("Room_Name").get_font("font").size = 80
		get_parent().get_node("Room_Name").rect_position.x -= 100
		get_parent().get_node("Start_Game").queue_free()
		global.prev_scene = "Select_Room.tscn"
		get_node("Network").init_client(global.server_ip)
	var start_game_button = get_parent().get_node("Start_Game")
	start_game_button.connect("pressed", self, "_button_pressed", [start_game_button.get_name(), seed_val, global.peer])