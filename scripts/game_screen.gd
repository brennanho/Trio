extends Container
var timer = Timer.new()

var cards = [
	'1_RHOM_BLUE_SOLID',
	'2_RHOM_BLUE_SOLID',
	'3_RHOM_BLUE_SOLID',
	'1_RHOM_BLUE_DOT',
	'2_RHOM_BLUE_DOT',
	'3_RHOM_BLUE_DOT',
	'1_RHOM_BLUE_EMPTY',
	'2_RHOM_BLUE_EMPTY',
	'3_RHOM_BLUE_EMPTY',
	'1_XXX_BLUE_SOLID',
	'2_XXX_BLUE_SOLID',
	'3_XXX_BLUE_SOLID',
	'1_XXX_BLUE_DOT',
	'2_XXX_BLUE_DOT',
	'3_XXX_BLUE_DOT',
	'1_XXX_BLUE_EMPTY',
	'2_XXX_BLUE_EMPTY',
	'3_XXX_BLUE_EMPTY',
	'1_CIRC_BLUE_SOLID',
	'2_CIRC_BLUE_SOLID',
	'3_CIRC_BLUE_SOLID',
	'1_CIRC_BLUE_DOT',
	'2_CIRC_BLUE_DOT',
	'3_CIRC_BLUE_DOT',
	'1_CIRC_BLUE_EMPTY',
	'2_CIRC_BLUE_EMPTY',
	'3_CIRC_BLUE_EMPTY',
	'1_RHOM_GREEN_SOLID',
	'2_RHOM_GREEN_SOLID',
	'3_RHOM_GREEN_SOLID',
	'1_RHOM_GREEN_DOT',
	'2_RHOM_GREEN_DOT',
	'3_RHOM_GREEN_DOT',
	'1_RHOM_GREEN_EMPTY',
	'2_RHOM_GREEN_EMPTY',
	'3_RHOM_GREEN_EMPTY',
	'1_XXX_GREEN_SOLID',
	'2_XXX_GREEN_SOLID',
	'3_XXX_GREEN_SOLID',
	'1_XXX_GREEN_DOT',
	'2_XXX_GREEN_DOT',
	'3_XXX_GREEN_DOT',
	'1_XXX_GREEN_EMPTY',
	'2_XXX_GREEN_EMPTY',
	'3_XXX_GREEN_EMPTY',
	'1_CIRC_GREEN_SOLID',
	'2_CIRC_GREEN_SOLID',
	'3_CIRC_GREEN_SOLID',
	'1_CIRC_GREEN_DOT',
	'2_CIRC_GREEN_DOT',
	'3_CIRC_GREEN_DOT',
	'1_CIRC_GREEN_EMPTY',
	'2_CIRC_GREEN_EMPTY',
	'3_CIRC_GREEN_EMPTY',
	'1_RHOM_RED_SOLID',
	'2_RHOM_RED_SOLID',
	'3_RHOM_RED_SOLID',
	'1_RHOM_RED_DOT',
	'2_RHOM_RED_DOT',
	'3_RHOM_RED_DOT',
	'1_RHOM_RED_EMPTY',
	'2_RHOM_RED_EMPTY',
	'3_RHOM_RED_EMPTY',
	'1_XXX_RED_SOLID',
	'2_XXX_RED_SOLID',
	'3_XXX_RED_SOLID',
	'1_XXX_RED_DOT',
	'2_XXX_RED_DOT',
	'3_XXX_RED_DOT',
	'1_XXX_RED_EMPTY',
	'2_XXX_RED_EMPTY',
	'3_XXX_RED_EMPTY',
	'1_CIRC_RED_SOLID',
	'2_CIRC_RED_SOLID',
	'3_CIRC_RED_SOLID',
	'1_CIRC_RED_DOT',
	'2_CIRC_RED_DOT',
	'3_CIRC_RED_DOT',
	'1_CIRC_RED_EMPTY',
	'2_CIRC_RED_EMPTY',
	'3_CIRC_RED_EMPTY'
]

var set = []

#Ensures there is atleast 1 set on the board
func make_board_valid():
	if cards.size() > 0:
		for i in range(1,13):
			if get_set_count() == 0: #Shuffle a card back into the deck from the table and draw a new one
				var card_node = get_node("card_" + str(i))
				var back_in = card_node.refresh_card()
				cards.append(back_in[0] + "_" + back_in[1] + "_" + back_in[2] + "_" + back_in[3])
				print("board_refresh")
			else:
				return get_set_count()
	else:
		global.refresh_globals()
		get_tree().change_scene("Main.tscn")
		

#Update the screen UI to display the number of sets available
func update_sets_available(num_sets):
	if num_sets == 1:
		get_parent().get_node("Sets_Remaining").text = '1 set available'
	else:
		get_parent().get_node("Sets_Remaining").text = str(num_sets) + ' sets available'

#Broadcasts a set found update to the game to all players
sync func update_game(set, player_id):
	if global.game_mode == "local":
		global.players_score[player_id] += 1
		get_parent().get_node("Color/Scores").get_node(str(player_id)).text = str(global.fruits[player_id%global.fruits.size()]) + " :  " + str(global.players_score[player_id])
	
	if cards.size() >= 3: #Refresh the board with new cards
		for i in range(3):
			var card_node = get_node(set[i][4])
			card_node.refresh_card()
	else: #Game over
		global.refresh_globals()
		get_tree().change_scene("Main.tscn")
	
	var num_sets = make_board_valid()
	update_sets_available(num_sets)

#Randomizes all cards in the deck	
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

#Check set logic		
func all_same(set):
	return set[0] == set[1] and set[1] == set[2]	
func all_diff(set):
	return set[0] != set[1] and set[1] != set[2] and set[0] != set[2]	
func is_valid_category(set):
	return all_same(set) or all_diff(set)

#Returns true if set is valid
func is_set(set):
	var colours = []
	var nums = []
	var shapes = []
	var shadings = []
	for card in set:
		colours.append(card[2])
		nums.append(card[0])
		shapes.append(card[1])
		shadings.append(card[3])
	return is_valid_category(colours) and is_valid_category(shapes) and is_valid_category(shadings) and is_valid_category(nums)

#Calculate the number of sets on the board
func get_set_count():
	var sets = []
	for i in range(1,10):
		var card_1 = get_node("card_" + str(i)).current_card
		for j in range(i+1,11):
			var card_2 = get_node("card_" + str(j)).current_card
			for k in range(j+1,12):
				var card_3 = get_node("card_" + str(k)).current_card
				var set = [card_1, card_2, card_3]
				if is_set(set):
					sets.append(set)
	return len(sets)

#Triggered when card is pressed, if 3 cards have been pressed, check if it is a set and update the game
func add_card(card):
	if card in set:
		set.erase(card)
	else:
		set.append(card)
		if set.size() == 3:	
			if is_set(set):
				if global.game_mode == "remote": #Online game
					var msg = "SET," + str(global.opp_socket_id) + "," + set[0][4].split("_")[-1] + "," + set[1][4].split("_")[-1] + "," + set[2][4].split("_")[-1]
					global.ws.get_peer(1).put_packet(msg.to_utf8())
					print("Sending to server:", msg)
					update_game(set, global.my_name)
					global.players_score[global.socket_id] += 1
					get_parent().get_node("Color/Scores").get_node(str(global.socket_id)).text = str(global.fruits[global.socket_id%global.fruits.size()]) + " :  " + str(global.players_score[global.socket_id])
				else: #Local game
					rpc("update_game", set, global.my_name)
			else:
				print("not a set")
			for i in range(3):
				var card_node = get_node(set[i][4])
				card_node.get_node("fade").play_backwards("fader")
				card_node.i += 1
			set.clear()

#Websocket signals
#For online gameplay, when opponent sends a set has been found		
func _set_found_received():
	var msg = global.ws.get_peer(1).get_packet().get_string_from_utf8()
	if msg.begins_with("SET"):
		msg = msg.split(",")
		var card_1 = msg[1]
		var card_2 = msg[2]
		var card_3 = msg[3]
		var set = []
		print("Opponent has found a set: ", card_1, card_2, card_3)
		global.players_score[global.opp_socket_id] += 1
		get_parent().get_node("Color/Scores").get_node(str(global.opp_socket_id)).text = str(global.fruits[global.opp_socket_id%global.fruits.size()]) + " :  " + str(global.players_score[global.opp_socket_id])
		if cards.size() >= 3: #Refresh the board with new cards
			set = [get_node("card_" + card_1).refresh_card(), get_node("card_" + card_2).refresh_card(), get_node("card_" + card_3).refresh_card()]
		else: #Game over
			global.refresh_globals()
			get_tree().change_scene("Main.tscn")
		var num_sets = make_board_valid()
		update_sets_available(num_sets)
	elif msg == "WIN":
		print("You win!")
		global.refresh_globals()
		get_tree().change_scene("res://Main.tscn")
	
func _connection_established(protocol):
	var msg = "Rejoining game".to_utf8()
	print(global.ws.get_peer(1).put_packet(msg))
func _connection_closed(reason):
	print("Connection closed:", reason)
	global.ws.get_peer(1).put_packet("ID: " + global.socket_id + "has disconnected")
func _connection_error():
	print("Could not connect to server")
	
#Intermitently ping the server so a timeout does not occur (30 secs)
func _on_ping_timeout():
	global.ws.get_peer(1).put_packet("PING".to_utf8())
	print("SENDING PING")

#Keep polling for messages from server
func _process(delta):
	global.ws.poll()
	
func _ready():
	var num_sets = make_board_valid()
	update_sets_available(num_sets)
	if global.game_mode == "remote":
		global.ws.connect("data_received", self, "_set_found_received")
		global.ws.connect("connection_established", self, "_connection_established")
		global.ws.connect("connection_closed", self, "_connection_closed")
		global.ws.connect("connection_error", self, "_connection_error")
		set_process(true)
	else: #local game i.e. same wifi or solo
		get_parent().get_node("Timer").stop()
		set_process(false)