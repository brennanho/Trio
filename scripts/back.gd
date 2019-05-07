extends TextureButton

#Go back to the main menu
func _on_Back_pressed():
	if global.network_role == global.ENET_SERVER and global.discover_thread != null:
		if global.discovery_on == true:
			global.discovery_on = false
			global.discover_thread.wait_to_finish()
	global.refresh_globals()
	if global.prev_scene == global.MAIN_SCENE:
		global.in_tutorial = true
	Transition.fade_to(global.prev_scene)
	
#Android back button
func _notification(what): 
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		_on_Back_pressed()