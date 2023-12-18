extends CharacterBody3D

@onready var camera := get_viewport().get_camera_3d()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var move_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Get the input direction and handle the looking around.
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	look_around(look_dir * delta * JOYSTICK_SENSITIVITY)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_around(event.relative * MOUSE_SENSITIVITY)


func look_around(direction: Vector2) -> void:
	rotate_y(-direction.x)
	camera.rotate_x(-direction.y)
	camera.rotation.x = clampf(camera.rotation.x, TAU * -0.25, TAU * 0.25)
