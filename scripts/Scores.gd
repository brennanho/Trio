extends VBoxContainer

func _ready():
	for player_name in global.players.keys():
		var player = Label.new()
		var font = DynamicFont.new()
		font.size = 30
		font.font_data = load("res://fonts/CallingCards_Reg_sample.ttf")
		player.text = "Player " + player_name + " :  " + str(global.players[player_name])
		player.align = player.ALIGN_RIGHT
		player.add_font_override("font", font)
		player.add_color_override("font_color", Color(0,0,0))
		player.name = player_name
		add_child(player)