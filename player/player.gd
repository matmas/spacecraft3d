extends RigidBody3D
class_name Player

@onready var camera := get_viewport().get_camera_3d()
@onready var neck := $Neck as Node3D
@onready var feet_collision_shape := $FeetCollisionShape3D as CollisionShape3D
@onready var body_collision_shape := $BodyCollisionShape3D as CollisionShape3D
@onready var crouched_body_collision_shape := $CrouchedBodyCollisionShape3D as CollisionShape3D

const WALK_SPEED = 2.5
const SPRINT_SPEED = 6.0
const JUMP_SPEED = 4.5
const ALIGN_SPEED = 2.0
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.00
const UPRIGHT_NECK_POSITION_Y = 1.2
const CROUCHED_NECK_POSITION_Y = 0.4

var look_direction_change := Vector2()
var target_neck_position_y := UPRIGHT_NECK_POSITION_Y

func _ready() -> void:
	max_contacts_reported = 1
	can_sleep = false


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var delta := get_physics_process_delta_time()
	var floor_info := _get_floor_info()
	var move_direction := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	print(state.total_gravity)

	if state.total_gravity:
		if floor_info:
			_set_crouched(Input.is_action_pressed(&"crouch"))
			var upward_speed := JUMP_SPEED if Input.is_action_pressed(&"jump") else 0.0
			var lateral_speed := SPRINT_SPEED if Input.is_action_pressed(&"sprint") else WALK_SPEED
			var movement_velocity := transform.basis * Vector3(move_direction.x * lateral_speed, upward_speed, move_direction.y * lateral_speed)
			if movement_velocity or Input.is_action_just_released(&"move_left") or Input.is_action_just_released(&"move_right") or Input.is_action_just_released(&"move_forward") or Input.is_action_just_released(&"move_backward"):
				state.linear_velocity = floor_info["linear_velocity"] + movement_velocity
		else:
			_set_crouched(false)
		neck.rotate_x(-look_direction_change.y)
		neck.rotation.x = clampf(neck.rotation.x, TAU * -0.25, TAU * 0.25)
	else:
		_set_crouched(false)
		var linear_acceleration_direction := Vector3(
			Input.get_axis(&"move_left", &"move_right"),
			Input.get_axis(&"move_down", &"move_up"),
			Input.get_axis(&"move_forward", &"move_backward"),
		).normalized()
		var linear_acceleration := linear_acceleration_direction * 1000.0
		state.apply_central_force(state.transform.basis * linear_acceleration)
		state.transform.basis = state.transform.rotated_local(Vector3.RIGHT, -look_direction_change.y).basis
		state.transform.basis = state.transform.rotated_local(Vector3.FORWARD, Input.get_axis(&"roll_left", &"roll_right") * delta).basis

	state.transform.basis = state.transform.rotated_local(Vector3.UP, -look_direction_change.x).basis
	look_direction_change = Vector2.ZERO

	if state.get_contact_count() > 0:
		_align_with_gravity(state)


func _process(delta: float) -> void:
	# Get the input direction and handle the looking around.
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	look_direction_change += look_dir * delta * JOYSTICK_SENSITIVITY

	neck.position.y = lerpf(neck.position.y, target_neck_position_y, 1 - pow(0.1, delta * 5.0))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_direction_change += event.relative * MOUSE_SENSITIVITY


func _align_with_gravity(state: PhysicsDirectBodyState3D) -> void:
	if state.total_gravity:
		var upright_vector := -state.total_gravity.normalized()
		var target_basis := _orthonormalize_yzx(Basis(
			upright_vector.cross(state.transform.basis.z),
			upright_vector,
			state.transform.basis.z
		))
		var delta := get_physics_process_delta_time()
		state.transform.basis = state.transform.basis.slerp(target_basis, 1 - pow(0.1, ALIGN_SPEED * delta)).orthonormalized()
		if upright_vector.dot(state.transform.basis.y) < 0.5:
			_set_crouched(true)


func _orthonormalize_yzx(b: Basis) -> Basis:
	var bb := Basis(b.y, b.z, b.x).orthonormalized()
	return Basis(bb.z, bb.x, bb.y)


func _set_crouched(crouched: bool) -> void:
	if not crouched and not _can_stand_up():
		return
	body_collision_shape.set_deferred(&"disabled", crouched)
	crouched_body_collision_shape.set_deferred(&"disabled", not crouched)
	target_neck_position_y = UPRIGHT_NECK_POSITION_Y if not crouched else CROUCHED_NECK_POSITION_Y


func _can_stand_up() -> bool:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = body_collision_shape.shape
	params.transform = body_collision_shape.global_transform
	params.exclude = [self]
	params.margin = -0.05
	var contact_points := get_world_3d().direct_space_state.collide_shape(params, 1)
	return contact_points.is_empty()


func _get_floor_info() -> Dictionary:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = feet_collision_shape.shape
	params.transform = feet_collision_shape.global_transform
	params.exclude = [self]
	return get_world_3d().direct_space_state.get_rest_info(params)
