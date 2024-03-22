extends RigidBody3D
class_name Player

@onready var upright_collision_shape := $UprightCollisionShape as CollisionShape3D
@onready var crouched_collision_shape := $CrouchedCollisionShape as CollisionShape3D
@onready var ball_collision_shape: CollisionShape3D = $BallCollisionShape
@onready var feet_collision_shape := $FeetCollisionShape as CollisionShape3D
@onready var head := $Head as Node3D

const WALK_SPEED = 2.5
const SPRINT_SPEED = 6.0
const CROUCHED_SPEED = 1.5
const JUMP_SPEED = 4.5
const ALIGN_SPEED = 2.0
const UPRIGHT_HEAD_POSITION_Y = 1.2
const CROUCHED_HEAD_POSITION_Y = 0.4
const BALL_HEAD_POSITION_Y = 0.2
const HEAD_ROTATION_TRANSFER_SPEED = 1.0
const HEAD_POSITION_ANIMATION_SPEED = 5.0

var look_direction_change := Vector2()
var previous_total_gravity := Vector3()
var target_head_position_y := UPRIGHT_HEAD_POSITION_Y


func _ready() -> void:
	max_contacts_reported = 1
	can_sleep = false


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Ignore one physics frame of zero gravity caused by disabling collision shape
	var total_gravity := state.total_gravity if state.total_gravity else previous_total_gravity
	var delta := get_physics_process_delta_time()

	if total_gravity:
		var floor_info := _get_floor_info()
		if floor_info:
			if InputHints.is_action_pressed(&"crouch"):
				_set_collision_shape(crouched_collision_shape)
			else:
				_set_collision_shape(upright_collision_shape)
			var move_direction := InputHints.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
			var upward_speed := JUMP_SPEED if InputHints.is_action_pressed(&"jump") else 0.0
			var horizontal_speed := (
				SPRINT_SPEED if InputHints.is_action_pressed(&"sprint") else WALK_SPEED
			) if not InputHints.is_action_pressed(&"crouch") else CROUCHED_SPEED
			var movement_velocity := transform.basis * Vector3(move_direction.x * horizontal_speed, upward_speed, move_direction.y * horizontal_speed)
			if movement_velocity or InputHints.is_action_just_released(&"move_left") or InputHints.is_action_just_released(&"move_right") or InputHints.is_action_just_released(&"move_forward") or InputHints.is_action_just_released(&"move_backward"):
				state.linear_velocity = floor_info["linear_velocity"] + movement_velocity
		head.rotate_x(-look_direction_change.y)
		head.rotation.x = clampf(head.rotation.x, TAU * -0.25, TAU * 0.25)
	else:
		var head_rotation_transfer_diff := head.rotation.x - lerpf(head.rotation.x, 0.0, 1 - pow(0.1, HEAD_ROTATION_TRANSFER_SPEED * delta))
		head.rotation.x -= head_rotation_transfer_diff
		state.transform.basis = state.transform.rotated_local(Vector3.RIGHT, head_rotation_transfer_diff).basis

		_set_collision_shape(upright_collision_shape)
		var linear_acceleration_direction := Vector3(
			InputHints.get_axis(&"move_left", &"move_right"),
			InputHints.get_axis(&"move_down", &"move_up"),
			InputHints.get_axis(&"move_forward", &"move_backward"),
		).normalized()
		var linear_acceleration := linear_acceleration_direction * 1000.0
		state.apply_central_force(state.transform.basis * linear_acceleration)
		state.transform.basis = state.transform.rotated_local(Vector3.RIGHT, -look_direction_change.y).basis
		state.transform.basis = state.transform.rotated_local(Vector3.FORWARD, InputHints.get_axis(&"roll_left", &"roll_right") * delta).basis

	state.transform.basis = state.transform.rotated_local(Vector3.UP, -look_direction_change.x).basis
	look_direction_change = Vector2.ZERO

	if state.get_contact_count() > 0:
		_align_with_gravity(state)
	previous_total_gravity = state.total_gravity


func _process(delta: float) -> void:
	# Get the input direction and handle the looking around.
	var look_dir := InputHints.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	var joypad_sensitivity := GameOptions.get_range_option("input", "joypad_sensitivity").get_value()
	look_direction_change += look_dir * delta * joypad_sensitivity

	# Animate head position
	head.position.y = lerpf(head.position.y, target_head_position_y, 1 - pow(0.1, HEAD_POSITION_ANIMATION_SPEED * delta))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_sensitivity := GameOptions.get_range_option("input", "mouse_sensitivity").get_value() * 0.001
		look_direction_change += event.relative * mouse_sensitivity * get_window().content_scale_factor


func _align_with_gravity(state: PhysicsDirectBodyState3D) -> void:
	if state.total_gravity:
		var upright_vector := -state.total_gravity.normalized()
		var target_basis := Basis(
			upright_vector.cross(state.transform.basis.z),
			upright_vector,
			state.transform.basis.z
		).orthonormalized()

		var delta := get_physics_process_delta_time()
		state.transform.basis = state.transform.basis.slerp(target_basis, 1 - pow(0.1, ALIGN_SPEED * delta)).orthonormalized()
		if upright_vector.dot(state.transform.basis.y) < 0.0:
			_set_collision_shape(ball_collision_shape)


func _set_collision_shape(collision_shape: CollisionShape3D) -> void:
	match collision_shape:
		upright_collision_shape:
			if not _can_stand_up():
				return
			if upright_collision_shape.disabled:
				upright_collision_shape.set_deferred(&"disabled", false)
			if not crouched_collision_shape.disabled:
				crouched_collision_shape.set_deferred(&"disabled", true)
			if not ball_collision_shape.disabled:
				ball_collision_shape.set_deferred(&"disabled", true)
			target_head_position_y = UPRIGHT_HEAD_POSITION_Y
		crouched_collision_shape:
			if not upright_collision_shape.disabled:
				upright_collision_shape.set_deferred(&"disabled", true)
			if crouched_collision_shape.disabled:
				crouched_collision_shape.set_deferred(&"disabled", false)
			if not ball_collision_shape.disabled:
				ball_collision_shape.set_deferred(&"disabled", true)
			target_head_position_y = CROUCHED_HEAD_POSITION_Y
		ball_collision_shape:
			if not upright_collision_shape.disabled:
				upright_collision_shape.set_deferred(&"disabled", true)
			if not crouched_collision_shape.disabled:
				crouched_collision_shape.set_deferred(&"disabled", true)
			if ball_collision_shape.disabled:
				ball_collision_shape.set_deferred(&"disabled", false)
			target_head_position_y = BALL_HEAD_POSITION_Y


func _can_stand_up() -> bool:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = upright_collision_shape.shape
	params.transform = upright_collision_shape.global_transform
	params.exclude = [self]
	params.margin = -0.05  # Ignore touching objects
	var contact_points := get_world_3d().direct_space_state.collide_shape(params, 1)
	return contact_points.is_empty()


func _get_floor_info() -> Dictionary:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = feet_collision_shape.shape
	params.transform = feet_collision_shape.global_transform
	params.exclude = [self]
	return get_world_3d().direct_space_state.get_rest_info(params)
