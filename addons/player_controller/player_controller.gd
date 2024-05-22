extends RigidBody3D
class_name PlayerController

@onready var upright_collision_shape := $UprightCollisionShape as CollisionShape3D
@onready var crouched_collision_shape := $CrouchedCollisionShape as CollisionShape3D
@onready var ball_collision_shape: CollisionShape3D = $BallCollisionShape as CollisionShape3D
@onready var feet_collision_shape := $FeetCollisionShape as CollisionShape3D
@onready var head := $Head as Node3D

@export var walk_speed := 2.5
@export var sprint_speed := 6.0
@export var crouched_speed := 1.5
@export var jump_speed := 4.5
@export var align_speed := 2.0
@export var head_rotation_transfer_speed := 1.0
@export var head_position_animation_speed := 5.0
@export var acceleration_in_zero_g := 1000.0
@export var upright_head_position_y := 1.2
@export var crouched_head_position_y := 0.4
@export var ball_head_position_y := 0.2

var look_direction_change := Vector2()
var previous_total_gravity := Vector3()
var target_head_position_y := upright_head_position_y


func _ready() -> void:
	max_contacts_reported = 1


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Ignore one physics frame of zero gravity caused by disabling collision shape
	var total_gravity := state.total_gravity if state.total_gravity else previous_total_gravity
	var delta := get_physics_process_delta_time()

	if total_gravity:
		var floor_info := _get_floor_info()
		if floor_info:
			if is_input_crouch():
				_set_collision_shape(crouched_collision_shape)
			else:
				_set_collision_shape(upright_collision_shape)
			var move_direction := get_input_move_direction()
			var upward_speed := jump_speed if is_input_jump() else 0.0
			var horizontal_speed := (
				sprint_speed if is_input_sprint() else walk_speed
			) if not is_input_crouch() else crouched_speed
			var movement_velocity := transform.basis * Vector3(move_direction.x * horizontal_speed, upward_speed, move_direction.y * horizontal_speed)
			if movement_velocity or is_input_move_left_released() or is_input_move_right_released() or is_input_move_forward_released() or is_input_move_backward_released():
				state.linear_velocity = floor_info["linear_velocity"] + movement_velocity
		head.rotate_x(-look_direction_change.y)
		head.rotation.x = clampf(head.rotation.x, TAU * -0.25, TAU * 0.25)
	else:
		var head_rotation_transfer_diff := head.rotation.x - lerpf(head.rotation.x, 0.0, 1 - pow(0.1, head_rotation_transfer_speed * delta))
		head.rotation.x -= head_rotation_transfer_diff
		state.transform.basis = state.transform.rotated_local(Vector3.RIGHT, head_rotation_transfer_diff).basis

		_set_collision_shape(upright_collision_shape)

		var linear_acceleration := Vector3()
		if get_selected_collider() and is_input_match_velocity():
			var velocity_to_match := PlayerControllerUtils.get_velocity(get_selected_collider())
			linear_acceleration = PlayerControllerUtils.clamp_vector_length(velocity_to_match - state.linear_velocity) * acceleration_in_zero_g
		else:
			var linear_acceleration_direction := state.transform.basis * get_input_move_acceleration_direction()
			linear_acceleration = linear_acceleration_direction * acceleration_in_zero_g
		state.apply_central_force(linear_acceleration)
		state.transform.basis = state.transform.rotated_local(Vector3.RIGHT, -look_direction_change.y).basis
		state.transform.basis = state.transform.rotated_local(Vector3.FORWARD, get_input_roll_axis() * delta).basis

	state.transform.basis = state.transform.rotated_local(Vector3.UP, -look_direction_change.x).basis
	look_direction_change = Vector2.ZERO

	if state.get_contact_count() > 0:
		_align_with_gravity(state)
	previous_total_gravity = state.total_gravity


func _process(delta: float) -> void:
	# Get the input direction and handle the looking around.
	var look_dir := get_input_look_direction()
	var joypad_sensitivity := get_joypad_sensitivity()
	look_direction_change += look_dir * delta * joypad_sensitivity

	# Animate head position
	head.position.y = lerpf(head.position.y, target_head_position_y, 1 - pow(0.1, head_position_animation_speed * delta))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_sensitivity := get_mouse_sensitivity() * 0.001
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
		state.transform.basis = state.transform.basis.slerp(target_basis, 1 - pow(0.1, align_speed * delta)).orthonormalized()
		if upright_vector.dot(state.transform.basis.y) < 0.0:
			_set_collision_shape(ball_collision_shape)


func _set_collision_shape(collision_shape: CollisionShape3D) -> void:
	var collision_shapes := [
		upright_collision_shape,
		crouched_collision_shape,
		ball_collision_shape,
	]
	match collision_shape:
		upright_collision_shape:
			if not _can_stand_up():
				return
			target_head_position_y = upright_head_position_y
		crouched_collision_shape:
			target_head_position_y = crouched_head_position_y
		ball_collision_shape:
			target_head_position_y = ball_head_position_y

	for col_shape in collision_shapes:
		if col_shape == collision_shape:
			if col_shape.disabled:
				col_shape.set_deferred(&"disabled", false)
		else:
			if not col_shape.disabled:
				col_shape.set_deferred(&"disabled", true)


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


func get_input_look_direction() -> Vector2:
	return Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")


func get_input_move_direction() -> Vector2:
	return Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")


func is_input_move_left_released() -> bool:
	return Input.is_action_just_released(&"move_left")


func is_input_move_right_released() -> bool:
	return Input.is_action_just_released(&"move_right")


func is_input_move_forward_released() -> bool:
	return Input.is_action_just_released(&"move_forward")


func is_input_move_backward_released() -> bool:
	return Input.is_action_just_released(&"move_backward")


func is_input_jump() -> bool:
	return Input.is_action_pressed(&"jump")


func is_input_sprint() -> bool:
	return Input.is_action_pressed(&"sprint")


func is_input_crouch() -> bool:
	return Input.is_action_pressed(&"crouch")


func get_input_move_acceleration_direction() -> Vector3:
	return Vector3(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_down", &"move_up"),
		Input.get_axis(&"move_forward", &"move_backward"),
	).normalized()


func get_input_roll_axis() -> float:
	return Input.get_axis(&"roll_left", &"roll_right")


func is_input_match_velocity() -> bool:
	return Input.is_action_pressed(&"match_velocity")


func get_selected_collider() -> Node3D:
	return null  # To be overridden in subclass


func get_mouse_sensitivity() -> float:
	return 2.0


func get_joypad_sensitivity() -> float:
	return 2.0
