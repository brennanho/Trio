extends Label

#Loads the highscore on screen
func _ready():
	self.text = "High Score:  " + str(global.load_data('score'))