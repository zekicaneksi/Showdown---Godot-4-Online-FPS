extends Node3D

var player_scene = preload("res://scenes/player.tscn")

func SpawnPlayer_Server(id):
	var spawnData = {
		"id": id,
		"name": GameManager.Players[id].name
	}
	$Players/MultiplayerSpawner.spawn(spawnData)

func DespawnPlayer(id):
	var players = $Players.get_tree().get_nodes_in_group("Players")
	for i in players:
		if i.name == str(id):
			i.queue_free()

@rpc("authority", "call_local")
func RespawnPlayer(id):
	var players = $Players.get_tree().get_nodes_in_group("Players")
	for i in players:
		if i.name == str(id):
			i.global_position = $SpawnLocation.global_position

func SpawnPlayer(data):
	var currentPlayer = player_scene.instantiate()
	currentPlayer.hit.connect(PlayerKilled.bind())
	currentPlayer.name = str(data.id)
	currentPlayer.get_node("NameLabel").text = data.name
	return currentPlayer

func PlayerKilled(killer_id, killed_id):
	GameManager.Players[killer_id.to_int()].score += 1
	RespawnPlayer.rpc(killed_id.to_int())
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Players/MultiplayerSpawner.set_spawn_function(SpawnPlayer)
	if OS.has_feature("dedicated_server"):
		multiplayer.peer_disconnected.connect(DespawnPlayer)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$Scoreboard.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tab"):
		$Scoreboard.show()
		for i in GameManager.Players:
			var id_label = Label.new()
			id_label.text = str(GameManager.Players[i].id)
			var name_label = Label.new()
			name_label.text = str(GameManager.Players[i].name)
			var score_label = Label.new()
			score_label.text = str(GameManager.Players[i].score)
			
			$Scoreboard/ScrollContainer/GridContainer.add_child(id_label)
			$Scoreboard/ScrollContainer/GridContainer.add_child(name_label)
			$Scoreboard/ScrollContainer/GridContainer.add_child(score_label)
	if Input.is_action_just_released("tab"):
		$Scoreboard.hide()
		for n in $Scoreboard/ScrollContainer/GridContainer.get_children():
			$Scoreboard/ScrollContainer/GridContainer.remove_child(n)
			n.queue_free()
