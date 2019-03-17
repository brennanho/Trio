extends TextureButton

const ANIM_NAME = "Help"
const ANIM_NAME2 = "Help2"

func _on_Help_pressed():
	get_node(ANIM_NAME).play(ANIM_NAME)

func _on_Back_button_down():
	get_parent().get_parent().get_node("Background").get_node(ANIM_NAME).get_node(ANIM_NAME).play_backwards(ANIM_NAME)

func _on_Next_button_down():
	get_parent().get_parent().get_node("Background").get_node(ANIM_NAME).get_node(ANIM_NAME).play(ANIM_NAME2)

func _on_Back2_button_down():
	get_parent().get_parent().get_node("Background").get_node(ANIM_NAME).get_node(ANIM_NAME).play_backwards(ANIM_NAME2)
