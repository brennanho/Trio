extends GridContainer

func _ready():
	for player_id in global.players_score.keys():
		var player = Label.new()
		var font = DynamicFont.new()
		font.size = 40
		font.font_data = load("res://fonts/CallingCards_Reg_sample.ttf")
		player.text =  str(global.fruits[player_id%global.fruits.size()]) + " : " + str(global.players_score[player_id])
		player.align = player.ALIGN_RIGHT
		player.add_font_override("font", font)
		player.add_color_override("font_color", Color(0,0,0))
		player.name = str(player_id)
		if str(player_id) == str(global.my_name):
			player.add_color_override("font_color", Color(1,0,0))
		add_child(player)