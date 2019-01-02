extends Container

func _button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load + ".tscn")
	
func _ready():
	for button in self.get_children():
		button.connect("pressed", self, "_button_pressed", [button.get_name()])