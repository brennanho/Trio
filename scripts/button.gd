extends TextureButton

func _on_Create_Game_pressed():
	global.network_role = "Server"
	global.server_ip = IP.get_local_addresses()[1]
	global.prev_scene = "Main.tscn"
	#get_tree().change_scene("Lobby.tscn")
	Transition.fade_to("Lobby.tscn")


func _on_Join_Game_pressed():
	global.network_role = "Client"
	global.prev_scene = "Main.tscn"
	#get_tree().change_scene("Select_Room.tscn")
	Transition.fade_to("Select_Room.tscn")