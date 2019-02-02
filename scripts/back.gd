extends Button

#Go back to the main menu
func _on_Back_pressed():
	if global.network_role == "Server":
		global.discovery_on = false
		global.discover_thread.wait_to_finish()
	global.refresh_globals()
	get_tree().change_scene(global.prev_scene)