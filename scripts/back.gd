extends Button

#Go back to the main menu
func _on_Back_pressed():
	get_tree().change_scene(global.prev_scene)
	global.refresh_globals()