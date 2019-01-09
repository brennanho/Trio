extends TextureButton

onready var cards = self.get_parent().cards
var current_card 
onready var card_scale
var scaler = 1.05
var i = 0

func refresh_card():
	var card_name = cards.pop_front()
	var image = load("res://Card_Sprites/" + card_name + ".png")
	set_normal_texture(image)
	current_card = card_name.split("_")
	return current_card

func card_pressed():
	var card = current_card
	card.append(self.get_name())
	get_parent().add_card(card)
	if i % 2 == 0:
		get_node("fade").play("fader")
	else:
		get_node("fade").play_backwards("fader")
	i += 1
		
func _ready():
	if (self.name == "card_1"):
		get_parent().shuffle_cards()
	current_card = refresh_card()
	card_scale = get_scale()
	self.connect("pressed", self, "card_pressed")