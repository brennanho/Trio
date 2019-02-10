extends Label
var timer

func _process(delta):
	self.text = str(stepify(timer.time_left, 1))
	if timer.is_stopped():
		var network_role = global.network_role
		global.refresh_globals()
		global.network_role = network_role
		global.prev_scene = "Main.tscn"
		Transition.fade_to("Lobby.tscn")
		set_process(false)
	
func _ready():
	timer = get_parent()
	timer.start()
	self.text = str(timer.time_left)
	self.add_color_override("font_color", Color(0,0,0))
	set_process(true)