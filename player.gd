extends RigidBody3D

@onready var ground_test: RayCast3D = $GroundTest
@onready var camera := get_viewport().get_camera_3d()
@onready var neck: Node3D = $Neck

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00

var look_direction_change = Vector2()


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var global_direction := transform.basis * Vector3(move_direction.x, 0, move_direction.y)

	if is_on_floor():
		var platform_velocity := Vector3.ZERO
		if ground_test.get_collider() is RigidBody3D:
			platform_velocity = ground_test.get_collider().linear_velocity

		state.linear_velocity.x = platform_velocity.x + global_direction.x * SPEED
		state.linear_velocity.z = platform_velocity.z + global_direction.z * SPEED

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			state.linear_velocity.y = JUMP_VELOCITY

	state.transform.basis = state.transform.rotated_local(Vector3(0, 1, 0), -look_direction_change.x).basis # rotate_y(-direction.x)
	neck.rotate_x(-look_direction_change.y)
	neck.rotation.x = clampf(neck.rotation.x, TAU * -0.25, TAU * 0.25)
	look_direction_change = Vector2.ZERO



func is_on_floor():
	return ground_test.is_colliding()


func _process(delta: float) -> void:
	# Get the input direction and handle the looking around.
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	look_direction_change += look_dir * delta * JOYSTICK_SENSITIVITY


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_direction_change += event.relative * MOUSE_SENSITIVITY
