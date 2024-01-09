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
	var players = $Players.get_tree().get_nodes_in_group("Players")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func PlayerKilled(killer_id, killed_id):
	GameManager.Players[killer_id.to_int()].score += 1
	
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
