extends RigidBody3D

@onready var camera := get_viewport().get_camera_3d()
@onready var neck: Node3D = $Neck
@onready var feet_collision_shape := $FeetCollisionShape3D

const WALK_SPEED = 2.5
const SPRINT_SPEED = 6.0
const JUMP_SPEED = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00

var look_direction_change := Vector2()


func _ready() -> void:
	max_contacts_reported = 10
	can_sleep = false


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var delta := get_physics_process_delta_time()

	# Align with gravity when touching something
	if state.get_contact_count() > 0:
		if not state.total_gravity.is_zero_approx():
			var upright_vector := -state.total_gravity.normalized()
			var target_basis := Basis(
				upright_vector.cross(-upright_vector.cross(state.transform.basis.x)),
				upright_vector,
				upright_vector.cross(-upright_vector.cross(state.transform.basis.z))
			).orthonormalized()
			state.transform.basis = state.transform.basis.slerp(target_basis, 1 - pow(0.1, 10.0 * delta))

	var is_on_floor := false
	var floor_velocity := Vector3.ZERO
	for i in range(max_contacts_reported):
		var is_contact := i < state.get_contact_count()
		if is_contact:
			if shape_owner_get_owner(state.get_contact_local_shape(i)) == feet_collision_shape:
				is_on_floor = true
				floor_velocity = state.get_contact_collider_velocity_at_position(i)
				break

	var move_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if is_on_floor:
		var upward_speed := JUMP_SPEED if Input.is_action_pressed("jump") else 0.0
		var lateral_speed := SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED
		var movement_velocity := transform.basis * Vector3(move_direction.x * lateral_speed, upward_speed, move_direction.y * lateral_speed)
		if movement_velocity or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward"):
			state.linear_velocity = floor_velocity + movement_velocity

	state.transform.basis = state.transform.rotated_local(Vector3.UP, -look_direction_change.x).basis
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
