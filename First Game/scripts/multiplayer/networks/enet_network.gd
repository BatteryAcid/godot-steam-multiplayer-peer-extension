extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var game_scene = preload("res://scenes/game.tscn")
var multiplayer_scene = preload("res://scenes/multiplayer_player.tscn")
var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var _players_spawn_node

func become_host():
	print("Starting host!")
	
	multiplayer_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	#multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_connected.connect(_player_joined)
	multiplayer.peer_disconnected.connect(_del_player)

	add_game_to_world()
	# TODO: delay this until game start
	#if not OS.has_feature("dedicated_server"):
		#_add_player_to_game(1)
	
func add_game_to_world():
	var game_scene = game_scene.instantiate()
	var world = get_tree().current_scene.get_node("World")
	world.add_child(game_scene)

func join_as_client(lobby_id):
	print("Player 2 joining")
	
	multiplayer_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

func _player_joined(id: int):
	print("player joined %s" % id)
	#TODO: this should do any pre-game setup
	# This was used instead of add_player_to_game signal
	_add_player_to_game(id)
	_add_player_to_game(1) # also add host

func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	await get_tree().create_timer(1).timeout
	_players_spawn_node = get_tree().current_scene.get_node("World/Game/Players")
	_players_spawn_node.add_child(player_to_add, true)
	
func _del_player(id: int):
	print("Player %s left the game!" % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()

	
	
	
	
	
	
	
	
