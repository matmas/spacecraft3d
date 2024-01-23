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

	if global_direction:
		state.linear_velocity.x = global_direction.x * SPEED
		state.linear_velocity.z = global_direction.z * SPEED
	else:
		state.linear_velocity.x = move_toward(state.linear_velocity.x, 0, SPEED)
		state.linear_velocity.z = move_toward(state.linear_velocity.z, 0, SPEED)

	state.transform.basis = state.transform.rotated_local(Vector3(0, 1, 0), -look_direction_change.x).basis # rotate_y(-direction.x)
	neck.rotate_x(-look_direction_change.y)
	neck.rotation.x = clampf(neck.rotation.x, TAU * -0.25, TAU * 0.25)
	look_direction_change = Vector2.ZERO


func _process(delta: float) -> void:
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and ground_test.is_colliding():
		#velocity.y = JUMP_VELOCITY
#
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
