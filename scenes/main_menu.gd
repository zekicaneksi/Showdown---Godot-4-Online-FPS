extends Control

var game_scene = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(ConnectedToServer)
	if OS.has_feature("dedicated_server"):
		StartGame()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ConnectedToServer():
	print("connected to server")
	GameManager.SendPlayerInformation.rpc_id(1, $NameInput.text, multiplayer.get_unique_id())
	StartGame()

func _on_join_button_pressed():
	GameManager.peer = ENetMultiplayerPeer.new()
	GameManager.peer.create_client(GameManager.Address, GameManager.Port)
	GameManager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(GameManager.peer)

func StartGame():
	var scene = game_scene.instantiate()
	get_tree().call_deferred("change_scene_to_packed",game_scene)
