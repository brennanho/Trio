extends Label

#Displays the room name for clients to join
func _ready():
	self.add_color_override("font_color", Color(0,0,0))
	if global.network_role == global.ENET_SERVER:
		self.text = global.player_name
	else:
		self.text = global.server_name