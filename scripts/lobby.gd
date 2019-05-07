extends VBoxContainer
const FONT_SIZE = 50
const BLACK = Color(0,0,0)
const GREEN = Color(0,1,0.25)
const OUTLINE_SIZE = 2
const FONT_PATH = "res://fonts/Robi-Regular.ttf"

onready var FONT = load(FONT_PATH)

sync func start_game(scene_to_load, seed_val, peer):
	if global.my_name == 1: #peer is server
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
	var player_num = 1
	for player in global.players_in_lobby.keys():
		add_player_to_screen(player_num, player, global.players_ips[player])
		player_num += 1
		
func add_player_to_screen(player_num, player_id, name):
	var player = Label.new()
	player.text = str(player_num) + ". " + name
	var font = DynamicFont.new()
	font.size = FONT_SIZE
	font.font_data = FONT
	font.outline_color = BLACK
	font.outline_size = OUTLINE_SIZE
	player.add_font_override("font", font)
	if str(player_id) == str(global.my_name):
		player.add_color_override("font_color", GREEN)
	player.align = ALIGN_CENTER
	player.valign = VALIGN_CENTER
	add_child(player)
	if len(global.players_in_lobby) == 1:
		get_parent().get_parent().get_node("Start_Game/Players_Ready").play("Player_Joined_Left")
	global.players_in_lobby[player_id] = player
	global.players_score[player_id] = 0
	global.players_ips[player_id] = name
	get_parent().get_node("Num_Players").text = str(len(global.players_in_lobby)) + " out of 6 players"
	
func remove_player_from_screen(player_id):
	remove_child(global.players_in_lobby[player_id])
	global.players_in_lobby.erase(player_id)
	global.players_score.erase(player_id)
	get_parent().get_node("Num_Players").text = str(len(global.players_in_lobby)) + " out of 6 players"
	if len(global.players_in_lobby) == 1:
		get_parent().get_parent().get_node("Start_Game/Players_Ready").play_backwards("Player_Joined_Left")

func _ready():
	var seed_val
	global.game_mode = global.LOCAL_GAME
	if global.network_role == global.ENET_SERVER:
		get_node("Network").init_server()
		randomize()
		seed_val = randi()
		add_player_to_screen(1,1, global.load_data('name'))
		global.discover_thread = Thread.new()
		global.discover_thread.start(get_node("Network"), "broadcast_to_clients", [null])
	else:
		#get_parent().get_parent().get_node("Start_Game/Title").text = "Reading to start"
		global.prev_scene = global.ROOMS_SCENE
		get_node("Network").init_client(global.server_ip)
	var start_game_button = get_parent().get_parent().get_node("Start_Game")
	start_game_button.connect("pressed", self, "_button_pressed", [start_game_button.get_name(), seed_val, global.peer])