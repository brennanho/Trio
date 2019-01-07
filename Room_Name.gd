extends Label

func _ready():
	self.add_color_override("font_color", Color(0,0,0))
	self.text = global.server_ip