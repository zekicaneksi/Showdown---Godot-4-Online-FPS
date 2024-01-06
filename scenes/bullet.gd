extends Node3D

var speed = 80.0

@onready var ray = $RayCast3D
@onready var mesh = $MeshInstance3D

var belongs_to_player = null

func set_up_variables(player_id):
	belongs_to_player = player_id

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	if ray.is_colliding():
		mesh.visible = false
		ray.enabled = false
		if ray.get_collider().is_in_group("Players"):
			ray.get_collider().emit_hit(belongs_to_player)
		queue_free()


func _on_timer_timeout():
	# Remove the bullet if it doesn't collide with anything
	queue_free()
