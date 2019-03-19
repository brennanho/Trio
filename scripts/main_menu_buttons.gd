extends TextureButton

func _on_Singleplayer_pressed():
	global.SINGLE_PLAYER = true
	global.network_role = global.ENET_SERVER
	randomize()
	global.seed_val = randi()
	Transition.fade_to(global.GAME_SCENE)

func _on_Multiplayer_pressed():
	global.SINGLE_PLAYER = false
	Transition.fade_to(global.MULTIPLAYER_SCENE)
	
func _ready():
	global.wait(5, null, get_parent().get_node("Singleplayer/Flying_Tiles/Tile3/Anim"))
	global.wait(5, null, get_parent().get_node("Singleplayer/Flying_Tiles/Tile4/Anim"))
	global.prev_scene = global.MAIN_SCENE