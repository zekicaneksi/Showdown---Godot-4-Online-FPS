extends Control

@export var Address = "127.0.0.1"
@export var Port = 3000
@export var Max_Clients = 128

var peer;

var game_scene = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(ConnectedToServer)
	multiplayer.connection_failed.connect(ConnectionFailed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func PlayerConnected(id):
	print("Player connected with id: " + str(id))

func PlayerDisconnected(id):
	print("Player disconnected with id: " + str(id))

func ConnectedToServer():
	print("connected to server")
	SendPlayerInformation.rpc_id(1, $NameInput.text, multiplayer.get_unique_id())
	
func ConnectionFailed():
	print("connection failed")

@rpc("authority", "call_local")
func StartGame():
	var scene = game_scene.instantiate()
	get_tree().change_scene_to_packed(game_scene)
	
	
@rpc("any_peer", "call_remote")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port, Max_Clients)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	SendPlayerInformation($NameInput.text, multiplayer.get_unique_id())

func _on_join_button_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, Port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_button_pressed():
	StartGame.rpc()
