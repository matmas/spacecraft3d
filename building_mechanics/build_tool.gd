extends Node3D
class_name BuildTool

@export_flags_3d_physics var raycast_collision_mask := 0b00000000_00000000_00000000_11111111

var _raycast := RayCast3D.new()
var _block: Block
var _collision_shape: CollisionShape3D
var _ghost_material := preload("ghost_shader_material.tres")


func _ready() -> void:
	_raycast.collision_mask = raycast_collision_mask
	_raycast.target_position = Vector3.FORWARD * 10.0
	var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent()  # Need physics uninterpolated position
	camera_parent.add_child(_raycast)
	_refresh()
	BuildLibrary.selection_changed.connect(_refresh)


func _refresh() -> void:
	if _block:
		remove_child(_block)
		_block.queue_free()
		_block = null
		_collision_shape = null

	var selected_block := BuildLibrary.selected_block
	if selected_block:
		_block = selected_block.instantiate() as Block
		_block.freeze = true
		_block.collision_layer = 0
		_block.collision_mask = 0
		_collision_shape = _block.get_node("CollisionShape") as CollisionShape3D
		var block_mesh := _block.get_node("Mesh") as MeshInstance3D
		block_mesh.material_override = _ghost_material
		_block.hide()  # correct position is set later in _process()
		add_child(_block)


func _physics_process(_delta: float) -> void:
	if _block:
		var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent()  # Need physics uninterpolated position
		if _raycast.is_colliding():
			var point := _raycast.get_collision_point()
			var normal := _raycast.get_collision_normal()
			_block.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y)
			_block.global_position = point + normal * 0.001
			if not _block.visible:
				_block.show()
				PhysicsInterpolation.apply(_block)

			if _is_collision_shape_colliding(_collision_shape):
				_ghost_material.set_shader_parameter(&"color", Color.RED)
			else:
				_ghost_material.set_shader_parameter(&"color", Color.GREEN)
				_allow_block_placement(_raycast.get_collider())
		else:
			_block.global_basis = global_basis
			_block.global_position = camera_parent.global_position - camera_parent.global_basis.z * 3.0
			_ghost_material.set_shader_parameter(&"color", Color.GREEN)
			_allow_block_placement(get_parent())


func _allow_block_placement(node_with_velocity: Node = null) -> void:
	if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
		var spawned_block := BuildLibrary.selected_block.instantiate() as Block
		add_child(spawned_block)
		spawned_block.global_transform = _block.global_transform
		PhysicsInterpolation.apply(spawned_block)

		if node_with_velocity is RigidBody3D:
			spawned_block.linear_velocity = node_with_velocity.linear_velocity


func _is_collision_shape_colliding(collision_shape: CollisionShape3D, margin: float = -0.05) -> bool:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = collision_shape.shape
	params.transform = collision_shape.global_transform
	params.margin = margin  # Ignore touching objects
	var contact_points := get_world_3d().direct_space_state.collide_shape(params, 1)
	return contact_points.size() != 0


## Calculates Basis from y and z vectors.
## If y and z are parallel then alternative_z is used instead of z.
func _basis_from_y_z(y: Vector3, z: Vector3, alternative_z: Vector3) -> Basis:
	var b := Basis(
		y.cross(z),
		y,
		z,
	).orthonormalized()
	if not b.is_conformal():
		b = Basis(
			y.cross(alternative_z),
			y,
			alternative_z,
		).orthonormalized()
	return b
