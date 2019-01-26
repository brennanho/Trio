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
	print(card)
	card.append(self.get_name())
	get_parent().add_card(card)
	get_node("fade").playback_speed = 2.5
	if i % 2 == 0:
		get_node("fade").play("fader")
		self.material.set_shader_param("outline_color", Color(0, 1, 0, 1))
	else:
		get_node("fade").play_backwards("fader")
		self.material.set_shader_param("outline_color", Color(0.9, 0.9, 0.9, 1))
	i += 1
		
func _ready():
	self.material.set_shader_param("outline_color", Color(0.9, 0.9, 0.9, 1))
	if (self.name == "card_1"):
		get_parent().shuffle_cards()
	get_node("fade").playback_speed = 2.5
	current_card = refresh_card()
	card_scale = get_scale()
	self.connect("pressed", self, "card_pressed")