extends TextureButton

func _on_Singleplayer_pressed():
	global.SINGLE_PLAYER = true
	global.network_role = global.ENET_SERVER
	randomize()
	global.seed_val = randi()
	global.in_tutorial = false
	Transition.fade_to(global.GAME_SCENE)

func _on_Multiplayer_pressed():
	global.SINGLE_PLAYER = false
	global.in_tutorial = false
	Transition.fade_to(global.MULTIPLAYER_SCENE)
	
func _ready():
	global.prev_scene = global.MAIN_SCENE