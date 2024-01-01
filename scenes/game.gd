extends Node3D

var player_scene = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	for i in GameManager.Players:
		var currentPlayer = player_scene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		currentPlayer.get_node("NameLabel").text = GameManager.Players[i].name
		add_child(currentPlayer)
		currentPlayer.global_position =  $SpawnLocation.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
