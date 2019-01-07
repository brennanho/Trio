extends TextureButton

onready var cards = self.get_parent().cards
var current_card 
onready var card_scale
var scaler = 1.05
var i = 0

func refresh_card():
	var card_name = cards.pop_front()
	var image = load("res://ro_sprites/" + card_name + ".png")
	set_normal_texture(image)
	current_card = card_name.split("_")
	return current_card

func card_pressed():
	var card = current_card
	card.append(self.get_name())
	get_parent().add_card(card)
	get_node("fade").play_backwards("fader")
	if i % 2 == 0:
		set_scale(get_scale()*scaler)
	else:
		set_scale(card_scale)
	i += 1
		
func _ready():
	if (self.name == "card_1"):
		get_parent().shuffle_cards()
	current_card = refresh_card()
	card_scale = get_scale()
	self.rect_size.x = 120
	self.rect_size.y = 160
	self.connect("pressed", self, "card_pressed")