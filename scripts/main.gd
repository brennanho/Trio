extends Container

func _button_pressed(scene_to_load):
	if scene_to_load == "Create_Game":
		global.network_role = "Server"
	else: # Join game
		global.server_ip = get_node("Join_Game/LineEdit").text
		global.network_role = "Client"
	global.prev_scene = "Main.tscn"
	get_tree().change_scene("Lobby.tscn")

func _ready():	
	for button in self.get_children():
		button.connect("pressed", self, "_button_pressed", [button.get_name()])