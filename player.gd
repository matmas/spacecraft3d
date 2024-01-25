extends CharacterBody3D

@onready var camera := get_viewport().get_camera_3d()
@onready var neck: Node3D = $Neck

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var look_direction_change = Vector2()


func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var move_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var global_direction := transform.basis * Vector3(move_direction.x, 0, move_direction.y)

	if is_on_floor():
		if global_direction:
			velocity = Vector3(global_direction.x * SPEED, 0, global_direction.z * SPEED)
		else:
			velocity = velocity.move_toward(Vector3.ZERO, SPEED)

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	move_and_slide()


	# Get the input direction and handle the looking around.
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	look_direction_change += look_dir * delta * JOYSTICK_SENSITIVITY

	rotate_y(-look_direction_change.x)
	neck.rotate_x(-look_direction_change.y)
	neck.rotation.x = clampf(neck.rotation.x, TAU * -0.25, TAU * 0.25)
	look_direction_change = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_direction_change += event.relative * MOUSE_SENSITIVITY
