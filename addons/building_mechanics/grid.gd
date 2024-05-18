extends RigidBody3D
class_name Grid

var cell_size := Vector3(0.5, 0.5, 0.5)
var _block_count := 0


func get_block_count() -> int:
	return _block_count


func _init() -> void:
	name = "Grid"
	mass = 0.001
	collision_layer = 0b00000000_00000000_00000000_00000001
	collision_mask = 0b00000000_00000000_00000001_11111111
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
		block.mass = 0.0  # _calculate_center_of_mass loops through all blocks, even those who are about to leave tree
		center_of_mass = _calculate_center_of_mass()
		_block_count -= 1


func _calculate_center_of_mass() -> Vector3:
	var result := Vector3()
	var total_mass := 0.0

	for child in get_children():
		if child is Block:
			var block := child as Block
			result += block.mass * (block.position + Utils.calculate_spatial_bounds(block).get_center())
			total_mass += block.mass

	return result / total_mass


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_move_origin_to_center_of_mass(state)


func _move_origin_to_center_of_mass(state: PhysicsDirectBodyState3D) -> void:
	var offset := state.center_of_mass_local
	if not offset.is_zero_approx():
		for child in get_children():
			if child is Node3D:
				(child as Node3D).position -= offset
		state.transform = state.transform.translated_local(offset)
		center_of_mass -= offset
