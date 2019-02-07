extends TextureProgress

func _on_TextureProgress_changed():
	pass
	
func _process(delta):
	self.value += 1 
	self.value = int(self.value) % 100
	
func _ready():
	set_process(true)
