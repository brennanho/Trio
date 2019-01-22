#All global variables to communicate between nodes in game
extends Node

var network_role
var seed_val
var my_name
var players_in_lobby = {}
var players_score = {}
var peer
var server_ip = "127.0.0.1"
var prev_scene
var game_mode 

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
	"RaspberrySalmonberry",
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
	
func update_remote_game(card1, card2, card3):
	print("Opponent found a set")

func refresh_globals():
	network_role = ""
	seed_val = 0
	players_in_lobby = {}
	players_score = {}
	my_name = -1
	server_ip = "127.0.0.1"
	prev_scene = ""
	if game_mode == "local":
		peer.close_connection()