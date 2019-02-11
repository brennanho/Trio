extends TextureButton

onready var cards = self.get_parent().get_parent().cards
var current_card
var i = 0

func refresh_card():
	if current_card != null:
		get_parent().get_parent().cards.append(PoolStringArray(current_card).join("_"))
	var card_name = cards.pop_front()
	var image = load("res://Card_Sprites/" + card_name + ".png")
	set_normal_texture(image)
	current_card = card_name.split("_")
	return current_card

func card_pressed():
	var card = current_card
	card.append(get_parent().get_name())
	get_parent().get_parent().add_card(card)
	if i % 2 == 0:
		self.rect_position.x += 15
		get_parent().self_modulate = "#002956"
	else:
		self.rect_position.x -= 15
		get_parent().self_modulate = "#ffffff"
	i += 1
		
func _ready():
	if (get_parent().get_name() == "card_1"):
		get_parent().get_parent().shuffle_cards()
	get_node("fade").playback_speed = 2
	current_card = refresh_card()
	self.connect("pressed", self, "card_pressed")