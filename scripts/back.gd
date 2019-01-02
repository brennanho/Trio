extends Button

func _change_to_last_scene():
	get_tree().change_scene(global.prev_scene)
	global.refresh_globals()

func _ready():
	self.connect("pressed", self, "_change_to_last_scene")