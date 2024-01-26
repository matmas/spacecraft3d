extends RigidBody3D

@onready var camera := get_viewport().get_camera_3d()
@onready var neck: Node3D = $Neck
@onready var feet_collision_shape := $FeetCollisionShape3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00

var look_direction_change = Vector2()


func _ready() -> void:
	max_contacts_reported = 10


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var global_direction := transform.basis * Vector3(move_direction.x, 0, move_direction.y)

	var is_on_floor := false
	var floor_velocity := Vector3.ZERO
	for i in range(max_contacts_reported):
		var is_contact := i < state.get_contact_count()
		if is_contact:
			if shape_owner_get_owner(state.get_contact_local_shape(i)) == feet_collision_shape:
				is_on_floor = true
				floor_velocity = state.get_contact_collider_velocity_at_position(i)
				break

	if is_on_floor:
		state.linear_velocity.x = floor_velocity.x + global_direction.x * SPEED
		state.linear_velocity.z = floor_velocity.z + global_direction.z * SPEED

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			state.linear_velocity.y = JUMP_VELOCITY

	state.transform.basis = state.transform.rotated_local(Vector3(0, 1, 0), -look_direction_change.x).basis # rotate_y(-direction.x)
	neck.rotate_x(-look_direction_change.y)
	neck.rotation.x = clampf(neck.rotation.x, TAU * -0.25, TAU * 0.25)
	look_direction_change = Vector2.ZERO


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
