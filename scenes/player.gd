extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# accumulators for camera
var rot_x = 0
var rot_y = 0

var LOOKAROUND_SPEED = 0.002

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _ready():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera3D.make_current()
	
func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0

		move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			# modify accumulated mouse rotation
			rot_x -= event.relative.x * LOOKAROUND_SPEED
			rot_y -= event.relative.y * LOOKAROUND_SPEED
			if rot_y > 0.8:
				rot_y = 0.8
			if rot_y < -0.8:
				rot_y = -0.8
			transform.basis = Basis() # reset rotation
			rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
			rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
