extends Label
var timer

#warning-ignore:unused_argument
func _on_On_Win_animation_finished(anim_name):
	timer.connect("timeout", self, "game_over")
	timer.set_wait_time(3)
	timer.start()

func show_placements():
	get_parent().get_parent().get_node("fireworks").visible = true
	var offset = 70
	var scores_in_order = global.players_score.values()
	var score_positions = []
	var prev_anim
	var x
	var y = 275
	scores_in_order.sort()
	scores_in_order.invert()
	for score in get_parent().get_parent().get_node("Score_Background/Scores").get_children():
		if score.visible:
			var score_points = int(score.text.split(':')[1])
			var score_idx = scores_in_order.find(score_points)
			while score_idx in score_positions:
				score_idx += 1
			prev_anim = score.get_node("On_Win")
			if len(global.players_score) > 3:
				x = 150
			else:
				x = 25
			prev_anim.get_animation("anim").track_set_key_value(0, 1, Vector2(x, y + score_idx*offset))
			prev_anim.play("anim")
			score_positions.append(score_idx)
		else:
			prev_anim.connect("animation_finished", self, "_on_On_Win_animation_finished")
			break
		
func game_over():
	if global.SINGLE_PLAYER == true:
		var score = int(get_parent().get_parent().get_node("Single_Score").text)
		if score > global.load_data('score'):
			global.save_data('score', score)
		Transition.fade_to(global.MAIN_SCENE)
	else:
		if global.players_score[global.my_name] > global.load_data('score'):
			global.save_data('score',global.players_score[global.my_name])
		global.refresh_globals(global.network_role)
		global.prev_scene = global.MULTIPLAYER_SCENE
		Transition.fade_to(global.LOBBY_SCENE)

remote func update_time(time):
	self.text = time_to_mmss(stepify(time, 1))
	if time == 0:
		if global.SINGLE_PLAYER:
			game_over()
			Transition.fade_to(global.MAIN_SCENE)
		else:
			OS.delay_msec(1000)
			show_placements()

#warning-ignore:unused_argument
func _process(delta):
	self.text = time_to_mmss(stepify(timer.time_left, 1))
	if global.SINGLE_PLAYER:
		update_time(timer.time_left)
	elif timer.is_stopped():
		rpc("update_time", 0)
		show_placements()
		set_process(false)
	else:
		rpc("update_time", timer.time_left)
		
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
	if global.network_role == global.ENET_SERVER or global.game_mode == global.REMOTE_GAME:
		set_process(true)
	else:
		set_process(false)
