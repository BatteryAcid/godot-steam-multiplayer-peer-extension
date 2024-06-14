extends Control


func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
#		_remove_single_player()
		NetworkManager.become_host(true)

func become_host():
	print("Become host pressed")
#	_remove_single_player()
	%MultiplayerMenu.hide()
	%SteamMenu.hide()
	
	# TODO: refactor this 
	NetworkManager.become_host()
	#%NetworkManager.become_host()
	
func join_as_client():
	print("Join as player 2")
	join_lobby()

func use_steam():
	print("Using Steam!")
	%MultiplayerMenu.hide()
	%SteamMenu.show()
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	NetworkManager.active_network_type = NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM

func list_steam_lobbies():
	print("List Steam lobbies")
	NetworkManager.list_lobbies()

func join_lobby(lobby_id = 0):
	print("Joining lobby %s" % lobby_id)
	#_remove_single_player()
	%MultiplayerMenu.hide()
	%SteamMenu.hide()
	$Panel.hide()
	NetworkManager.join_as_client(lobby_id)
	#%NetworkManager.join_as_client(lobby_id)

func _on_lobby_match_list(lobbies: Array):
	print("On lobby match list")
	
	for lobby_child in $SteamMenu/Lobbies/VBoxContainer.get_children():
		lobby_child.queue_free()
		
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		
		if lobby_name != "":
			var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
			
			var lobby_button: Button = Button.new()
			lobby_button.set_text(lobby_name + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100, 30))
			lobby_button.add_theme_font_size_override("font_size", 32)
			
			var fv = FontVariation.new()
			fv.set_base_font(load("res://assets/fonts/PixelOperator8.ttf"))
			lobby_button.add_theme_font_override("font", fv)
			lobby_button.set_name("lobby_%s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			
			$SteamMenu/Lobbies/VBoxContainer.add_child(lobby_button)
			
func on_start():
	print("on start pressed")
	NetworkManager.start_game()
	$Panel.hide()

	
