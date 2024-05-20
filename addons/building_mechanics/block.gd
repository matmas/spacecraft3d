extends StaticBody3D
class_name Block

@export var display_name := ""
@export_range(0.001, 1000, 0.001, "or_greater", "exp", "suffix:kg") var mass := 1.0

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
			_check_connectivity()
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


func _check_connectivity() -> void:
	var visited := {}
	for neighbor in neighbors:  # Main branches to test
		if visited.is_empty():
			neighbor._depth_first_search(visited)
		elif neighbor not in visited:
			var new_grid := Grid.new(grid.collision_layer, grid.collision_mask, grid.block_collision_mask)
			new_grid.transform = grid.transform
			new_grid.linear_velocity = grid.linear_velocity
			new_grid.angular_velocity = grid.angular_velocity
			grid.get_parent().add_child(new_grid)
			neighbor._depth_first_search(visited, new_grid)


func _depth_first_search(visited: Dictionary, new_grid: Grid = null) -> void:
	if self not in visited:
		visited[self] = true
		if new_grid:
			_move_to_grid(new_grid)
		for neighbor in neighbors:
			neighbor._depth_first_search(visited, new_grid)


func _move_to_grid(grid_: Grid) -> void:
	#reparent.call_deferred(grid_, false)  # Also triggers child_exiting_tree, child_entered_tree, NOTIFICATION_EXIT_TREE, NOTIFICATION_ENTER_TREE
	#for shape in _grid_collision_shapes:
		#shape.reparent(grid_)
	grid_.add_child(self.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS + DuplicateFlags.DUPLICATE_SIGNALS + DuplicateFlags.DUPLICATE_GROUPS))
	self.queue_free()
