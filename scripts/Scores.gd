extends GridContainer

#CONSTANTS
const FONT_SIZE_BIG = 55
const FONT_SIZE_MED = 45
const FONT_SIZE_SMALL = 40
const BLACK = Color(0,0,0)
const GREEN = Color(0,1,0.25)
const WHITE = Color(1,1,1)
const OUTLINE_SIZE = 2
const FONT_PATH = "res://fonts/Robi-Regular.ttf"

#VARS
onready var FONT = load(FONT_PATH)

func _animation_finished(nill):
	self.visible = false

func _ready():
	self.add_color_override("", Color(0.1,0.5,1))
	var i = 1
	for player_id in global.players_score.keys():
		var player = get_node("Player" + str(i))
		player.visible = true
		var font = player.get_font("font")
		if len(global.players_score) > 3:		
			font.size = FONT_SIZE_SMALL
		else:
			self.columns = 1
			self.margin_left += 40
			font.size = FONT_SIZE_MED
			if len(global.players_score) == 2:
				self.margin_top += 10
				font.size = FONT_SIZE_BIG
		font.outline_color = BLACK
		font.outline_size = OUTLINE_SIZE
		player.text =  global.players_ips[player_id] + ": " + str(global.players_score[player_id])
		player.add_font_override("font", font)
		player.add_color_override("font_color", WHITE)
		player.name = str(player_id)
		if str(player_id) == str(global.my_name):
			player.add_color_override("font_color", GREEN)
		var firework = get_node("Firework").duplicate()
		firework.global_position = player.rect_position
		player.add_child(firework)
		i += 1