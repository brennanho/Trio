extends TextureButton

func refresh_cards():
	get_parent().get_node("Set?/card_1/card/Change").play("Change")
	get_parent().get_node("Set?/card_2/card/Change").play("Change")
	var rand_num = randi() % 100
	if rand_num <= 50:
		get_parent().get_node("Set?/card_3/card/Change").get_animation("Change").track_set_enabled(2, true)
	else:
		get_parent().get_node("Set?/card_3/card/Change").get_animation("Change").track_set_enabled(2, false)
	get_parent().get_node("Set?/card_3/card/Change").play("Change")
	
func make_set():
	var set = []
	for i in range(3):
		set.append(get_parent().get_node("Set?/card_" + str(i+1) + "/card").current_card)
	while !get_parent().get_node("Set?").is_set(set):
		get_parent().get_node("Set?/card_1/card").refresh_card()
		var card = get_parent().get_node("Set?/card_1/card").current_card
		set[0] = card
	return true
	
func _on_Yes_pressed():
	var set = []
	for i in range(3):
		set.append(get_parent().get_node("Set?/card_" + str(i+1) + "/card").current_card)
	if get_parent().get_node("Set?").is_set(set):
		get_parent().get_node("correct").play("anim")
	refresh_cards()

func _on_No_pressed():
	var set = []
	for i in range(3):
		set.append(get_parent().get_node("Set?/card_" + str(i+1) + "/card").current_card)
	if !get_parent().get_node("Set?").is_set(set):
		get_parent().get_node("correct").play("anim")
	refresh_cards()
		
func _ready():
	refresh_cards()
	randomize()
