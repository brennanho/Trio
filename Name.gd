extends Label

func _process(delta):
	self.text = get_node("Name").text
	
func _ready():
	set_process(true)