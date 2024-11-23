extends StaticBody3D
class_name Block

@export var block_type: BlockType

var grid: Grid
var neighbors: Array[Block] = []  # Touching blocks
var _grid_collision_shapes: Array[CollisionShape3D] = []


func _to_string() -> String:
	return "Block:%s" % name


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if get_parent() is Grid:
				grid = get_parent() as Grid
		NOTIFICATION_PREDELETE:  # Runs before NOTIFICATION_EXIT_TREE
			for neighbor in neighbors:
				neighbor.neighbors.erase(self)
			for shape in _grid_collision_shapes:
				if is_instance_valid(shape):  # Can be already freed e.g. when freeing whole scene
					shape.queue_free()
			if grid:
				grid.neighbors_of_just_deleted_blocks.append_array(neighbors)
		NOTIFICATION_EXIT_TREE:
			grid = null


func _ready() -> void:
	if grid:
		_add_collision_shapes_to_grid()
		for neighbor in _find_neighbors_in_grid():
			neighbors.append(neighbor)
			neighbor.neighbors.append(self)


func _add_collision_shapes_to_grid() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			var collision_shape := child as CollisionShape3D
			var grid_collision_shape := collision_shape.duplicate() as CollisionShape3D
			grid.add_child(grid_collision_shape)
			grid_collision_shape.global_transform = collision_shape.global_transform
			_grid_collision_shapes.append(grid_collision_shape)


func _find_neighbors_in_grid() -> Array[Block]:
	var result: Array[Block] = []
	for direction in [Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN, Vector3.BACK, Vector3.FORWARD]:
		for collider in BuildingMechanicsUtils.get_colliders_of_physics_body(self, grid.block_collision_mask, -0.02, self.basis * direction * 0.04):
				if collider is Block:
					var neighbor := collider as Block
					if neighbor.grid == grid:
						result.append(neighbor)
	return result
