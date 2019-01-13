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

func refresh_globals():
	network_role = ""
	seed_val = 0
	players = {}
	players_in_lobby = []
	my_name = ""
	peer.close_connection()
	server_ip = "127.0.0.1"
	prev_scene = ""