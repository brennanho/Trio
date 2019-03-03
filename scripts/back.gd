extends TextureButton

#Go back to the main menu
func _on_Back_pressed():
	if global.network_role == global.ENET_SERVER:
		if global.discovery_on == true:
			global.discovery_on = false
			global.discover_thread.wait_to_finish()
	global.refresh_globals()
	Transition.fade_to(global.prev_scene)