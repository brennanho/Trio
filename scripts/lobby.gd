extends VBoxContainer
var start_title

sync func start_game(scene_to_load, seed_val, peer):
	if peer.get_unique_id() == 1: #peer is server
		peer.refuse_new_connections = true
	
	global.seed_val = seed_val
	global.prev_scene = get_tree().current_scene
	get_tree().change_scene(scene_to_load + ".tscn")

func _button_pressed(scene_to_load, seed_val, peer):
	rpc("start_game", scene_to_load, seed_val, peer)

func add_players_to_screen(players):
	for player in global.players.keys():
		if not (player in global.players_in_lobby):
			add_player_to_screen(player)
		
func add_player_to_screen(player_name):
	global.players[player_name] = 0 # score
	var player = Label.new()
	player.text = "Player " + player_name
	player.add_color_override("font_color", Color(0,0,0))
	player.align = ALIGN_CENTER
	player.valign = VALIGN_CENTER
	add_child(player)
	global.players_in_lobby.append(player_name)
	get_node("Start_Game").text = start_title + str(global.players.size())

func _ready():
	var seed_val
	start_title = get_node("Start_Game").text + "    Players: "
	if global.network_role == "Server":
		global.peer = get_node("Network").init_server()
		randomize()
		seed_val = randi()
		global.my_name = str(global.peer.get_unique_id())
		add_player_to_screen(global.my_name)
	else:
		get_node("Start_Game").disabled = true
		global.peer = get_node("Network").init_client(global.server_ip)
	var start_game_button = self.get_child(0)
	start_game_button.connect("pressed", self, "_button_pressed", [start_game_button.get_name(), seed_val, global.peer])