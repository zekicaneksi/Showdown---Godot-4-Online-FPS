extends Node

var Address = "127.0.0.1"
var Port = 3000
var Max_Clients = 128

var peer;

var Players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connection_failed.connect(ConnectionFailed)
	
	if OS.has_feature("dedicated_server"):
		GameManager.peer = ENetMultiplayerPeer.new()
		var error = GameManager.peer.create_server(GameManager.Port, GameManager.Max_Clients)
		if error != OK:
			print("cannot host: " + str(error))
			return
		GameManager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		
		multiplayer.set_multiplayer_peer(GameManager.peer)
		print("Hosting...")

func PlayerConnected(id):
	print("Player connected with id: " + str(id))

func PlayerDisconnected(id):
	print("Player disconnected with id: " + str(id))
	
func ConnectionFailed():
	print("connection failed")
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
