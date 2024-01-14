extends Node

var Address
var Port
var Max_Clients = 128

var peer;

var Players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Reading the env variables
	var env_file = FileAccess.open("res://env.json", FileAccess.READ)
	if env_file == null:
		print("Please provide the env file")
		get_tree().quit()
		return
	var env_content_text = env_file.get_as_text()
	var env_dict = JSON.parse_string(env_content_text)
	
	Address = env_dict["ADDRESS"]
	Port = env_dict["PORT"]
		
	if OS.has_feature("dedicated_server"):
		multiplayer.peer_connected.connect(PlayerConnected)
		multiplayer.peer_disconnected.connect(PlayerDisconnected)
	
		GameManager.peer = ENetMultiplayerPeer.new()
		var error = GameManager.peer.create_server(GameManager.Port, GameManager.Max_Clients)
		if error != OK:
			print("cannot host: " + str(error))
			return
		GameManager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		
		multiplayer.set_multiplayer_peer(GameManager.peer)
		print("Hosting on port " + str(Port) + "...")

func PlayerConnected(id):
	print("Player connected with id: " + str(id))

func PlayerDisconnected(id):
	print("Player disconnected with id: " + str(id))
	GameManager.Players.erase(id)
	
@rpc("any_peer", "call_remote")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
		
		var game_node = get_parent().get_node("Game")
		game_node.SpawnPlayer_Server(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
