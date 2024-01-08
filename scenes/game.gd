extends Node3D

var player_scene = preload("res://scenes/player.tscn")

func SpawnPlayer(id):
	var currentPlayer = player_scene.instantiate()
	currentPlayer.hit.connect(PlayerKilled.bind())
	currentPlayer.name = str(id)
	#currentPlayer.get_node("NameLabel").text = GameManager.Players[id].name
	currentPlayer.get_node("NameLabel").text = "teatatw"
	$Players.add_child.call_deferred(currentPlayer)
	currentPlayer.global_position = $SpawnLocation.global_position

func DespawnPlayer(id):
	GameManager.Players.erase(id)
	var players = $Players.get_tree().get_nodes_in_group("Players")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func PlayerKilled(killer_id, killed_id):
	print("telling form server: " + killer_id + "killed" + killed_id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("dedicated_server"):
		multiplayer.peer_connected.connect(SpawnPlayer)
		multiplayer.peer_disconnected.connect(DespawnPlayer)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$Scoreboard.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tab"):
		$Scoreboard.show()
		print(GameManager.Players)
	if Input.is_action_just_released("tab"):
		$Scoreboard.hide()
