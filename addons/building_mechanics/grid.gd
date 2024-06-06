extends RigidBody3D
class_name Grid

var _block_count := 0
var block_collision_mask: int  # Set by the build_tool when creating new Grid
var neighbors_of_just_deleted_blocks: Array[Block] = []


func get_block_count() -> int:
	return _block_count


func _init(collision_layer_: int = 1, collision_mask_: int = 1, block_collision_mask_: int = 1) -> void:
	collision_layer = collision_layer_
	collision_mask = collision_mask_
	block_collision_mask = block_collision_mask_
	name = "Grid"
	mass = 0.001
	center_of_mass_mode = CENTER_OF_MASS_MODE_CUSTOM
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)


func _on_child_entered_tree(node: Node) -> void:
	if node is Block:
		_block_count += 1
		var block := node as Block
		mass += block.mass
		center_of_mass = _calculate_center_of_mass()


func _on_child_exiting_tree(node: Node) -> void:
	if node is Block:
		var block := node as Block
		mass -= block.mass
		var exclude := block
		center_of_mass = _calculate_center_of_mass(exclude)
		_block_count -= 1
		if _block_count == 0:
			queue_free()


func _calculate_center_of_mass(exclude: Block = null) -> Vector3:
	var result := Vector3()
	var total_mass := 0.0

	for child in get_children():
		if child is Block and child != exclude:
			var block := child as Block
			result += block.mass * (block.position + Utils.calculate_spatial_bounds(block).get_center())
			total_mass += block.mass

	return result / total_mass


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_split_disjointed_blocks()  # Before _move_origin_to_center_of_mass to prevent moving split grids
	_move_origin_to_center_of_mass(state)


func _move_origin_to_center_of_mass(state: PhysicsDirectBodyState3D) -> void:
	var offset := state.center_of_mass_local
	if not offset.is_zero_approx():
		for child in get_children():
			if child is Node3D:
				(child as Node3D).position -= offset
		state.transform = state.transform.translated_local(offset)
		center_of_mass -= offset


func _split_disjointed_blocks() -> void:
	if neighbors_of_just_deleted_blocks:
		var visited: Dictionary[Block, bool]
		for neighbor in neighbors_of_just_deleted_blocks:
			if visited.is_empty():
				_depth_first_search(neighbor, visited)
			elif neighbor not in visited:
				var new_grid := Grid.new(collision_layer, collision_mask, block_collision_mask)
				new_grid.transform = transform
				new_grid.linear_velocity = linear_velocity
				new_grid.angular_velocity = angular_velocity
				get_parent().add_child(new_grid)

				_depth_first_search(neighbor, visited, new_grid)
		neighbors_of_just_deleted_blocks.clear()


func _depth_first_search(block: Block, visited: Dictionary[Block, bool], new_grid: Grid = null) -> void:
	if block not in visited:
		visited[block] = true
		if new_grid:
			_move_to_grid(block, new_grid)
		for neighbor in block.neighbors:
			_depth_first_search(neighbor, visited, new_grid)


func _move_to_grid(block: Block, new_grid: Grid) -> void:
	block.reparent(new_grid)  # Also triggers child_exiting_tree, child_entered_tree, NOTIFICATION_EXIT_TREE, NOTIFICATION_ENTER_TREE
	BuildingMechanicsUtils.fix_physics_interpolation(block)
	for shape in block._grid_collision_shapes:
		shape.reparent(new_grid)
