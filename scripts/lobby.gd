extends VBoxContainer
var start_title

sync func start_game(scene_to_load, seed_val, peer):
	if peer.get_unique_id() == 1: #peer is server
		global.discovery_on = false
		global.discover_thread.wait_to_finish()
		peer.refuse_new_connections = true
		global.udp_sock.close()
	
	global.seed_val = seed_val
	global.prev_scene = get_tree().current_scene
	get_tree().change_scene(scene_to_load + ".tscn")

func _button_pressed(scene_to_load, seed_val, peer):
	rpc("start_game", scene_to_load, seed_val, peer)

func add_players_to_screen(players):
	for player in global.players_in_lobby.keys():
		add_player_to_screen(player)
		
func add_player_to_screen(player_id):
	global.players_score[player_id] = 0 # score
	var player = Label.new()
	player.text = str(global.fruits[player_id%global.fruits.size()])
	var font = DynamicFont.new()
	font.size = 40
	font.font_data = load("res://fonts/CallingCards_Reg_sample.ttf")
	player.add_font_override("font", font)
	player.add_color_override("font_color", Color(0,0,0))
	if str(player_id) == str(global.my_name):
		player.add_color_override("font_color", Color(1,0,0))
	player.align = ALIGN_CENTER
	player.valign = VALIGN_CENTER
	add_child(player)
	global.players_in_lobby[player_id] = player
	get_node("Start_Game").text = start_title + str(global.players_in_lobby.size())
	
func remove_player_from_screen(player_id):
	remove_child(global.players_in_lobby[player_id])
	global.players_in_lobby.erase(player_id)
	global.players_score.erase(player_id)
	get_node("Start_Game").text = start_title + str(global.players_in_lobby.size())

func _ready():
	var seed_val
	global.game_mode = "local"
	start_title = get_node("Start_Game").text + "    Players: "
	if global.network_role == "Server":
		global.peer = get_node("Network").init_server()
		randomize()
		seed_val = randi()
		add_player_to_screen(1)
		global.discover_thread = Thread.new()
		global.discover_thread.start(get_node("Network"), "broadcast_to_clients", [null])
	else:
		get_node("Start_Game").disabled = true
		get_node("Network").init_client(global.server_ip)
	var start_game_button = self.get_child(0)
	start_game_button.connect("pressed", self, "_button_pressed", [start_game_button.get_name(), seed_val, global.peer])