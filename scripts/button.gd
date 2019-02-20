extends TextureButton

func _on_Create_Game_pressed():
	global.network_role = "Server"
	global.server_ip = global.get_host_ip()
	global.prev_scene = "Main.tscn"
	Transition.fade_to("Lobby.tscn")

func _on_Join_Game_pressed():
	global.network_role = "Client"
	global.prev_scene = "Main.tscn"
	Transition.fade_to("Select_Room.tscn")