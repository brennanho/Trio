extends GridContainer

#CONSTANTS
const FONT_SIZE_BIG = 45
const FONT_SIZE_SMALL = 40
const BLACK = Color(0,0,0)
const RED = Color(1,0,0)
const FONT_PATH = "res://fonts/Robi-Regular.ttf"

#VARS
onready var FONT = load(FONT_PATH)

func _animation_finished(nill):
	self.visible = false

func _ready():
	self.add_color_override("", Color(0.1,0.5,1))
	for player_id in global.players_score.keys():
		var player = Label.new()
		var font = DynamicFont.new()
		if len(global.players_score) > 1:		
			font.size = FONT_SIZE_SMALL
		else:
			font.size = FONT_SIZE_BIG
		font.font_data = FONT
		player.text =  global.players_ips[player_id] + ": " + str(global.players_score[player_id])
		player.align = player.ALIGN_RIGHT
		player.add_font_override("font", font)
		player.add_color_override("font_color", BLACK)
		player.name = str(player_id)
		if str(player_id) == str(global.my_name):
			player.add_color_override("font_color", RED)
		var firework = get_node("Firework").duplicate()
		firework.global_position = player.rect_position
		player.add_child(firework)
		add_child(player)