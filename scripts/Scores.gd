extends GridContainer

func _ready():
	self.add_color_override("", Color(0.1,0.5,1))
	for player_id in global.players_score.keys():
		var player = Label.new()
		var font = DynamicFont.new()
		font.size = 40
		font.font_data = load("res://fonts/Robi-Regular.ttf")
		player.text =  str(global.fruits[player_id%global.fruits.size()]) + " : " + str(global.players_score[player_id])
		player.align = player.ALIGN_RIGHT
		player.add_font_override("font", font)
		player.add_color_override("font_color", Color(0,0,0))
		player.name = str(player_id)
		if str(player_id) == str(global.my_name):
			player.add_color_override("font_color", Color(1,0,0))
		add_child(player)