extends TextureButton

onready var cards = self.get_parent().get_parent().cards
var current_card
var BUTTON_UP_POS
var BUTTON_DOWN_POS
var card_imgs = {}

const CARD_SPRITES_PATH = "res://Card_Sprites/"
const DARK_BLUE = "#002956"
const BLACK = "#ffffff"
const CARD_OFFSET = 15

func refresh_card():
	if current_card != null:
		get_parent().get_parent().cards.append(PoolStringArray(current_card).join("_"))
	var card_name = cards.pop_front()
	var image = card_imgs[card_name]
	set_normal_texture(image)
	current_card = card_name.split("_")
	return current_card

func button_up(not_set=false):
	if !not_set:
		get_node("Press").play_backwards("Press")
	else:
		get_node("Press").play_backwards("Press")
		get_node("Fade").play_backwards("fader")
	get_parent().self_modulate = BLACK
		

func button_down():
	var anim = get_node("Press").get_animation("Press")
	var idx = anim.find_track(".:rect_position")
	anim.track_set_key_value(idx,1, Vector2(BUTTON_DOWN_POS, self.rect_position.y))
	get_node("Press").play("Press")
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
	for card in cards:
		card_imgs[card] = load(CARD_SPRITES_PATH + card + ".png")
	BUTTON_UP_POS = self.rect_position.x
	BUTTON_DOWN_POS = self.rect_position.x + CARD_OFFSET
	if (get_parent().get_name() == "card_1"):
		get_parent().get_parent().shuffle_cards()
	current_card = refresh_card()
	self.toggle_mode = true
	self.connect("toggled", self, "_card_pressed") 