extends TextureButton

const ANIM_NAME = "Help"

func _on_Help_pressed():
	get_node(ANIM_NAME).play(ANIM_NAME)

func _on_Back_button_down():
	get_parent().get_parent().get_node(ANIM_NAME).get_node(ANIM_NAME).play_backwards(ANIM_NAME)