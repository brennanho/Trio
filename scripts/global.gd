#All global variables to communicate between nodes in game
extends Node

var network_role
var seed_val
var my_name
var players = {}
var players_in_lobby = []
var peer
var server_ip = "127.0.0.1"
var prev_scene

func refresh_globals():
	network_role = ""
	seed_val = 0
	players = {}
	players_in_lobby = []
	my_name = ""
	peer.close_connection()
	server_ip = "127.0.0.1"
	prev_scene = ""