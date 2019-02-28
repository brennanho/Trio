#All global variables to communicate between nodes in game
extends Node

signal timer_end
var network_role
var seed_val
var my_name
var players_in_lobby = {}
var players_score = {}
var players_ips = {}
var peer = null
var discovery_on = true
var server_ip = "127.0.0.1"
var udp_sock
var prev_scene
var game_mode 
var discover_thread
var high_score = 0

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
	
#Save current high score	
func save_score(score):
	var data = File.new()
	data.open("user://game.save", File.WRITE)
	var save_data = {"score": score}
	data.store_line(to_json(save_data))
	data.close()
		
#Load high score on game start
func load_score():
	var data = File.new()
	data.open("user://game.save", File.READ)
	if data.get_len() == 0:
		data.close()
		return 0
	else:
		var load_data = parse_json(data.get_line())
		data.close()
		return load_data['score']
	
func ip_to_name(ip):
	var hashed = 0
	ip = ip.split('.')
	for num in ip:
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
	return ips[-1]

func wait(seconds):
    self._create_timer(self, seconds, true, "_emit_timer_end_signal")
    yield(self,"timer_end")
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
	
func refresh_globals():
	network_role = ""
	seed_val = 0
	players_in_lobby = {}
	players_score = {}
	my_name = -1
	udp_sock.close()
	if game_mode == "local" and typeof(peer) == 17: #Valid peer object
		peer.close_connection()