extends Node3D
class_name BuildTool

@export_flags_3d_physics var raycast_collision_mask := 0b00000000_00000000_00000000_11111111

var _raycast := RayCast3D.new()
var _piece: Piece
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
	if _piece:
		remove_child(_piece)
		_piece.queue_free()
		_piece = null
		_collision_shape = null

	var selected_piece := BuildLibrary.selected_piece
	if selected_piece:
		_piece = selected_piece.instantiate() as Piece
		_piece.freeze = true
		_piece.collision_layer = 0
		_piece.collision_mask = 0
		_collision_shape = _piece.get_node("CollisionShape") as CollisionShape3D
		var piece_mesh := _piece.get_node("Mesh") as MeshInstance3D
		piece_mesh.material_override = _ghost_material
		_piece.hide()  # correct position is set later in _process()
		add_child(_piece)


func _physics_process(_delta: float) -> void:
	if _piece:
		var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent()  # Need physics uninterpolated position
		if _raycast.is_colliding():
			var point := _raycast.get_collision_point()
			var normal := _raycast.get_collision_normal()
			_piece.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y)
			_piece.global_position = point + normal * 0.001
			if not _piece.visible:
				_piece.show()
				PhysicsInterpolation.apply(_piece)

			var params := PhysicsShapeQueryParameters3D.new()
			params.shape = _collision_shape.shape
			params.transform = _collision_shape.global_transform
			params.exclude = [self]
			params.margin = -0.05  # Ignore touching objects
			var contact_points := get_world_3d().direct_space_state.collide_shape(params, 1)

			if contact_points:
				_ghost_material.set_shader_parameter(&"color", Color.RED)
			else:
				_ghost_material.set_shader_parameter(&"color", Color.GREEN)
				_allow_block_placement(_raycast.get_collider())
		else:
			_piece.global_basis = global_basis
			_piece.global_position = camera_parent.global_position - camera_parent.global_basis.z * 3.0
			_ghost_material.set_shader_parameter(&"color", Color.GREEN)
			_allow_block_placement(get_parent())


func _allow_block_placement(node_with_velocity: Node = null) -> void:
	if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
		var spawned_piece := BuildLibrary.selected_piece.instantiate() as Piece
		add_child(spawned_piece)
		spawned_piece.global_transform = _piece.global_transform
		PhysicsInterpolation.apply(spawned_piece)

		if node_with_velocity is RigidBody3D:
			spawned_piece.linear_velocity = node_with_velocity.linear_velocity


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
