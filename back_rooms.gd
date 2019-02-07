extends Button

func _on_Back_pressed():
	global.refresh_globals()
	get_tree().change_scene("Main.tscn")
