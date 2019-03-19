extends TextureButton

func _on_Create_Game_pressed():
	global.network_role = global.ENET_SERVER
	global.server_ip = global.get_host_ip()
	global.prev_scene = global.MULTIPLAYER_SCENE
	Transition.fade_to(global.LOBBY_SCENE)

func _on_Join_Game_pressed():
	global.network_role = global.ENET_CLIENT
	global.prev_scene = global.MULTIPLAYER_SCENE
	Transition.fade_to(global.ROOMS_SCENE)
	
func _ready():
	global.wait(5, null, get_parent().get_node("Create_Game/Flying_Tiles/Tile3/Anim").play("Anim"))
	global.wait(5, null, get_parent().get_node("Create_Game/Flying_Tiles/Tile4/Anim").play("Anim"))