extends Label
var timer
	
func game_over():
	if global.SINGLE_PLAYER == true:
		if int(get_parent().get_parent().get_node("Single_Score").text) > global.load_score:
			global.save_score(int(get_parent().get_parent().get_node("Single_Score").text))
			Transition.fade_to(global.MAIN_SCENE)
	else:
		if global.players_score[global.my_name] > global.load_score():
			global.save_score(global.players_score[global.my_name])
	var network_role = global.network_role
	global.refresh_globals()
	global.network_role = network_role
	global.prev_scene = global.MAIN_SCENE
	Transition.fade_to(global.LOBBY_SCENE)

remote func update_time(time):
	self.text = time_to_mmss(stepify(time, 1))
	if time <= 0.5:
		OS.delay_msec(1000)
		game_over()

func _process(delta):
	self.text = time_to_mmss(stepify(timer.time_left, 1))
	if global.SINGLE_PLAYER == true:
		update_time(timer.time_left)
	else:
		rpc("update_time", timer.time_left)
	if timer.is_stopped():
		rpc("update_time", 0)
		game_over()
		set_process(false)
		
func time_to_mmss(time):
	time = int(time)
	if time < 60:
		if time < 10:
			return "0:0" + str(time)
		return "0:" + str(time)
	elif time % 60 == 0:
		return str(time/60) + ":00"
	else:
		if time%60 < 10:
			return str(time/60) + ":0" + str(time%60)
		return str(time/60) + ":" + str(time%60)
	
func _ready():
	timer = get_parent()
	timer.start()
	self.text = time_to_mmss(timer.time_left)
	self.add_color_override("font_color", Color(0,0,0))
	if global.network_role == global.ENET_SERVER:
		set_process(true)
	else:
		set_process(false)