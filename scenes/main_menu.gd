extends Control

@export var Address = "127.0.0.1"
@export var Port = 3000
@export var Max_Clients = 128

var peer;

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
	
func ConnectionFailed():
	print("connection failed")

func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port, Max_Clients)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")

func _on_join_button_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, Port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_button_pressed():
	pass # Replace with function body.
