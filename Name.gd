extends LineEdit

onready var text_node = get_node("Name")

func _on_Name_text_changed(new_text):
	text_node.text = new_text

func _on_Name_text_entered(new_text):
	if text_node.text == "":
		text_node.text = global.load_data('name')
	global.save_data('name', text_node.text)

func _ready():
	var name = global.load_data('name')
	text_node.text = name