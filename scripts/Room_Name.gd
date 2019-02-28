extends Label

#Displays the room name (ip address for clients to join)
func _ready():
	self.add_color_override("font_color", Color(0,0,0))
	self.text = global.ip_to_name(global.server_ip)