extends LineEdit

func _on_Name_text_entered(new_text):
	if self.text == "":
		global.save_data('name', self.placeholder_text)
	else:
		global.save_data('name', self.text)

func _ready():
	self.text = global.load_data('name')
	global.player_name = self.text

func _on_Name_text_changed(new_text):
	if len(new_text) >= self.max_length:
		self.text = new_text.substr(0,self.max_length-1)
