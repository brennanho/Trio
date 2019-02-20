extends Label
var timer
	
func game_over():
	if global.players_score[global.my_name] > global.load_score():
		global.save_score(global.players_score[global.my_name])
	var network_role = global.network_role
	global.refresh_globals()
	global.network_role = network_role
	global.prev_scene = "Main.tscn"
	Transition.fade_to("Lobby.tscn")

remote func update_time(time):
	self.text = str(stepify(time, 1))
	if time <= 0.5:
		OS.delay_msec(1000)
		game_over()

func _fixed_process(delta):
	self.text = str(stepify(timer.time_left, 1))
	rpc("update_time", timer.time_left)
	if timer.is_stopped():
		rpc("update_time", 0)
		game_over()
		set_process(false)
	
func _ready():
	timer = get_parent()
	timer.start()
	self.text = str(timer.time_left)
	self.add_color_override("font_color", Color(0,0,0))
	if global.network_role == "Server":
		set_process(true)
	else:
		set_process(false)