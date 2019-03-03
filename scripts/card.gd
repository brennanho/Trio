extends TextureButton

onready var cards = self.get_parent().get_parent().cards
var current_card
var BUTTON_UP_POS
var BUTTON_DOWN_POS

const PLAYBACK_SPEED = 2
const CARD_SPRITES_PATH = "res://Card_Sprites/"
const DARK_BLUE = "#002956"
const BLACK = "#ffffff"
const CARD_OFFSET = 15

func refresh_card():
	if current_card != null:
		get_parent().get_parent().cards.append(PoolStringArray(current_card).join("_"))
	var card_name = cards.pop_front()
	var image = load(CARD_SPRITES_PATH + card_name + ".png")
	set_normal_texture(image)
	current_card = card_name.split("_")
	return current_card

func button_up():
	self.rect_position.x = BUTTON_UP_POS
	get_parent().self_modulate = BLACK

func button_down():
	self.rect_position.x = BUTTON_DOWN_POS
	get_parent().self_modulate = DARK_BLUE
	
func _card_pressed(pressed):
	if pressed:
		button_down()
	else:
		button_up()
	var card = current_card
	card.append(get_parent().get_name())
	get_parent().get_parent().add_card(card)
		
func _ready():
	BUTTON_UP_POS = self.rect_position.x
	BUTTON_DOWN_POS = self.rect_position.x + CARD_OFFSET
	if (get_parent().get_name() == "card_1"):
		get_parent().get_parent().shuffle_cards()
	get_node("fade").playback_speed = PLAYBACK_SPEED
	current_card = refresh_card()
	self.toggle_mode = true
	self.connect("toggled", self, "_card_pressed") 