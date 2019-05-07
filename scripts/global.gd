#All global variables to communicate between nodes in game
extends Node

signal timer_end
var network_role
var seed_val = 0
var my_name
var players_in_lobby = {}
var players_score = {}
var players_ips = {}
var peer = null
var discovery_on = true
var SINGLE_PLAYER = false
var server_ip = "127.0.0.1"
var udp_sock
var prev_scene
var game_mode 
var discover_thread
var high_score = 0
var player_name
var server_name
var cards
var game_data = {'name': 'Player', 'score': 0}
var in_tutorial = true

#CONSTS
const LOOPBACK = "127.0.0.1"
const ENET_SERVER = "Server"
const ENET_CLIENT = "Client"
const LOCAL_GAME = "Local"
const REMOTE_GAME = "Remote"
const SAVE_FILE = "user://game.cfg"

#SCENES
const MAIN_SCENE = "Main.tscn"
const MULTIPLAYER_SCENE = "Multiplayer.tscn"
const ROOMS_SCENE = "Select_Room.tscn"
const LOBBY_SCENE = "Lobby.tscn"
const GAME_SCENE = "Start_Game.tscn"


var socket_id
var opp_socket_id
var ws
var fruits = [
	"Apple",
	"Apricot",
	"Avocado",
	"Banana",
	"Bilberry",
	"Blackberry",
	"Blackcurrant",
	"Blueberry",
	"Boysenberry",
	"Currant",
	"Cherry",
	"Cherimoya",
	"Chico fruit",
	"Cloudberry",
	"Coconut",
	"Cranberry",
	"Cucumber",
	"Sugar apple",
	"Damson",
	"Date",
	"Dragonfruit",
	"Durian",
	"Elderberry",
	"Feijoa",
	"Fig",
	"Goji berry",
	"Gooseberry",
	"Grape",
	"Raisin",
	"Grapefruit",
	"Guava",
	"Honeyberry",
	"Huckleberry",
	"Jabuticaba",
	"Jackfruit",
	"Jambul",
	"Jujube",
	"Kiwifruit",
	"Kumquat",
	"Lemon",
	"Lime",
	"Loquat",
	"Longan",
	"Lychee",
	"Mango",
	"Marionberry",
	"Melon",
	"Cantaloupe",
	"Honeydew",
	"Watermelon",
	"Mulberry",
	"Nectarine",
	"Nance",
	"Olive",
	"Clementine",
	"Mandarine",
	"Tangerine",
	"Papaya",
	"Passionfruit",
	"Peach",
	"Pear",
	"Persimmon",
	"Physalis",
	"Plantain",
	"Pineapple",
	"Pomegranate",
	"Pomelo",
	"Quince",
	"Raspberry",
	"Salmonberry",
	"Rambutan",
	"Redcurrant",
	"Salak",
	"Satsuma",
	"Soursop",
	"Star fruit",
	"Strawberry",
	"Tamarillo",
	"Tamarind",
	"Yuzu"]
	
#Save data in json file	
func save_data(key, val):
	var data = File.new()
	data.open(SAVE_FILE, File.WRITE)
	game_data[key] = val
	data.store_line(to_json(game_data))
	data.close()

func default(key):
	if key == 'score':
		return 0
	elif key == 'name':
		return "Player"
	return ERR_INVALID_PARAMETER		

func load_data(key):
	var data = File.new()
	data.open(SAVE_FILE, File.READ)
	if data.get_len() != 0:
		var load_data = parse_json(data.get_as_text())
		data.close()
		if key in load_data.keys():
			return load_data[key]
		else:
			return default(key)
	else:
		data.close()
		return default(key)
		
func load_file():
	var data = File.new()
	data.open(SAVE_FILE, File.READ)
	if data.get_len() == 0:
		return game_data
	return parse_json(data.get_as_text())
	
func ip_to_name(name):
	if typeof(name) == TYPE_INT:
		return "Bob"
	if typeof(name) == TYPE_STRING:
		if name == LOOPBACK:
			return "Connect to WiFi"
	var hashed = 0
	name = name.split('.')
	for num in name:
		hashed += int(num)
	return fruits[hashed%fruits.size()]
	
func get_host_ip():
	var ips = []
	var bad_ips = ['169.254', '127.0.0.1', '0:0'] 
	for ip in IP.get_local_addresses():
		if len(ip) <= 15:
			var ip_ok = true
			for bad_ip in bad_ips:
				if ip.begins_with(bad_ip):
					ip_ok = false
					break
			if ip_ok:
				ips.append(ip)
	if len(ips) == 0:
		return LOOPBACK
	return ips[-1]

func wait(seconds, firework=null, flying_tile=null):
	var wr
	var wrf
	if firework != null:
		wr = weakref(firework)
	if flying_tile != null:
		wrf = weakref(flying_tile)
	self._create_timer(self, seconds, true, "_emit_timer_end_signal")
	yield(self,"timer_end")
	if wr != null and wr.get_ref():
		firework.visible = false
	if wrf != null and wrf.get_ref():
		flying_tile.play("Anim")
	
func _emit_timer_end_signal():
	emit_signal("timer_end")
	
func _create_timer(object_target, float_wait_time, bool_is_oneshot, string_function):
    var timer = Timer.new()
    timer.set_one_shot(bool_is_oneshot)
    timer.set_timer_process_mode(0)
    timer.set_wait_time(float_wait_time)
    timer.connect("timeout", object_target, string_function)
    self.add_child(timer)
    timer.start()
	
func refresh_globals(role=""):
	network_role = role
	seed_val = 0
	players_in_lobby = {}
	players_ips = {}
	players_score = {}
	my_name = -1
	if udp_sock != null:
		udp_sock.close()
	if game_mode == LOCAL_GAME and typeof(peer) == 17: #Valid peer object
		peer.close_connection()