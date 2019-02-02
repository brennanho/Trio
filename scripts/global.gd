#All global variables to communicate between nodes in game
extends Node

signal timer_end
var network_role
var seed_val
var my_name
var players_in_lobby = {}
var players_score = {}
var peer = null
var discovery_on = true
var server_ip = "127.0.0.1"
var udp_sock
var prev_scene
var game_mode 
var discover_thread

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
	"GrapeRaisin",
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
	"Solanum quitoense",
	"Strawberry",
	"Tamarillo",
	"Tamarind",
	"Yuzu"]

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
	global.udp_sock.close()
	if game_mode == "local" and typeof(peer) == 17: #Valid peer object
		if peer.get_connection_status() != 0: #disconnected already
			peer.close_connection()