extends GridContainer
const FONT_SIZE = 45
const BLACK = Color(0,0,0)
const RED = Color(1,0,0)

func _ready():
	self.add_color_override("", Color(0.1,0.5,1))
	for player_id in global.players_score.keys():
		var player = Label.new()
		var font = DynamicFont.new()
		font.size = FONT_SIZE
		font.font_data = load("res://fonts/Robi-Regular.ttf")
		player.text =  global.ip_to_name(global.players_ips[player_id])
		player.align = player.ALIGN_RIGHT
		player.add_font_override("font", font)
		player.add_color_override("font_color", BLACK)
		player.name = str(player_id)
		if str(player_id) == str(global.my_name):
			player.add_color_override("font_color", RED)
		add_child(player)