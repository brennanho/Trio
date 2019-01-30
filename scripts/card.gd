extends TextureButton

onready var cards = self.get_parent().cards
var current_card 
var i = 0

func refresh_card():
	#print(self.texture_normal.resource_path.split("/")[-1].split(".")[0])
	var card_name = cards.pop_front()
	var image = load("res://Card_Sprites/" + card_name + ".png")
	set_normal_texture(image)
	current_card = card_name.split("_")
	return self.texture_normal.resource_path.split("/")[-1].split(".")[0].split("_")

func card_pressed():
	var card = current_card
	print(self.texture_normal.resource_path.split("/")[-1].split(".")[0])
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
	get_node("fade").playback_speed = 2
	current_card = refresh_card()
	self.connect("pressed", self, "card_pressed")