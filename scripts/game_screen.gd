extends Container

var cards = [
	"green_1_oval_solid",
	"green_2_oval_solid",
	"green_3_oval_solid",
	"green_1_rectangle_solid",
	"green_2_rectangle_solid",
	"green_3_rectangle_solid",
	"green_1_triangle_solid",
	"green_2_triangle_solid",
	"green_3_triangle_solid",
	"green_1_oval_hollow",
	"green_2_oval_hollow",
	"green_3_oval_hollow",
	"green_1_rectangle_hollow",
	"green_2_rectangle_hollow",
	"green_3_rectangle_hollow",
	"green_1_triangle_hollow",
	"green_2_triangle_hollow",
	"green_3_triangle_hollow",
	"green_1_oval_shaded",
	"green_2_oval_shaded",
	"green_3_oval_shaded",
	"green_1_rectangle_shaded",
	"green_2_rectangle_shaded",
	"green_3_rectangle_shaded",
	"green_1_triangle_shaded",
	"green_2_triangle_shaded",
	"green_3_triangle_shaded",
	"red_1_oval_solid",
	"red_2_oval_solid",
	"red_3_oval_solid",
	"red_1_rectangle_solid",
	"red_2_rectangle_solid",
	"red_3_rectangle_solid",
	"red_1_triangle_solid",
	"red_2_triangle_solid",
	"red_3_triangle_solid",
	"red_1_oval_hollow",
	"red_2_oval_hollow",
	"red_3_oval_hollow",
	"red_1_rectangle_hollow",
	"red_2_rectangle_hollow",
	"red_3_rectangle_hollow",
	"red_1_triangle_hollow",
	"red_2_triangle_hollow",
	"red_3_triangle_hollow",
	"red_1_oval_shaded",
	"red_2_oval_shaded",
	"red_3_oval_shaded",
	"red_1_rectangle_shaded",
	"red_2_rectangle_shaded",
	"red_3_rectangle_shaded",
	"red_1_triangle_shaded",
	"red_2_triangle_shaded",
	"red_3_triangle_shaded",
	"blue_1_oval_solid",
	"blue_2_oval_solid",
	"blue_3_oval_solid",
	"blue_1_rectangle_solid",
	"blue_2_rectangle_solid",
	"blue_3_rectangle_solid",
	"blue_1_triangle_solid",
	"blue_2_triangle_solid",
	"blue_3_triangle_solid",
	"blue_1_oval_hollow",
	"blue_2_oval_hollow",
	"blue_3_oval_hollow",
	"blue_1_rectangle_hollow",
	"blue_2_rectangle_hollow",
	"blue_3_rectangle_hollow",
	"blue_1_triangle_hollow",
	"blue_2_triangle_hollow",
	"blue_3_triangle_hollow",
	"blue_1_oval_shaded",
	"blue_2_oval_shaded",
	"blue_3_oval_shaded",
	"blue_1_rectangle_shaded",
	"blue_2_rectangle_shaded",
	"blue_3_rectangle_shaded",
	"blue_1_triangle_shaded",
	"blue_2_triangle_shaded",
	"blue_3_triangle_shaded",
] 

var set = []

sync func update_game(set, name):
	print(cards.size())
	global.players[name] += 1
	get_parent().get_node("Scores").get_node(name).text = "Player " + name + " :  " + str(global.players[name])
	
	if cards.size() >= 3:
		for i in range(3):
			var card_node = get_node(set[i][4])
			card_node.refresh_card()
	
	var refreshes = 0
	while get_set_count() == 0 and refreshes < cards.size() and cards.size() > 0:
		var card_node = get_node(set[0][4])
		var back_in = card_node.refresh_card()
		cards.append(back_in[0] + "_" + back_in[1] + "_" + back_in[2] + "_" + back_in[3])
		refreshes += 1
		print("board refresh")
	
	if refreshes >= cards.size(): #game over
		global.refresh_globals()
		get_tree().change_scene("Main.tscn")
	
func shuffle_cards():
	seed(global.seed_val)	
	for i in range(cards.size()):
		var swap_index = randi() % cards.size()
		var swap_card = cards[swap_index]
		while swap_card == cards[i]:
			swap_index = randi() % cards.size()
			swap_card = cards[swap_index]
		cards[swap_index] = cards[i]
		cards[i] = swap_card
		
func all_same(set):
	return set[0] == set[1] and set[1] == set[2]
	
func all_diff(set):
	return set[0] != set[1] and set[1] != set[2] and set[0] != set[2]
	
func is_valid_category(set):
	return all_same(set) or all_diff(set)

func is_set(set):
	var colours = []
	var nums = []
	var shapes = []
	var shadings = []
	for card in set:
		colours.append(card[0])
		nums.append(card[1])
		shapes.append(card[2])
		shadings.append(card[3])
	return is_valid_category(colours) and is_valid_category(shapes) and is_valid_category(shadings) and is_valid_category(nums)

func get_set_count():
	var sets = 0
	for i in range(1,10):
		var card_1 = get_node("card_" + str(i)).current_card
		for j in range(i+1,11):
			var card_2 = get_node("card_" + str(j)).current_card
			for k in range(j+1,12):
				var card_3 = get_node("card_" + str(k)).current_card
				var set = [card_1, card_2, card_3]
				if is_set(set):
					sets += 1
					#print(set)
	return sets

func add_card(card):
	if card in set:
		set.erase(card)
	else:
		set.append(card)
		if set.size() == 3:	
			if is_set(set):
				print(set)
				rpc("update_game", set, global.my_name)
			else:
				print("not a set")
			for i in range(3):
				var card_node = get_node(set[i][4])
				card_node.set_scale(card_node.card_scale)
				card_node.i += 1
			print(get_set_count())
			set.clear()
	print(set)
	
func _ready():
	print(global.players)
	print(global.my_name)