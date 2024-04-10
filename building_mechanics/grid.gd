extends RigidBody3D
class_name Grid


func _init() -> void:
	name = "Grid"
	mass = 0.001
	collision_layer = 0b00000000_00000000_00000000_00000001
	collision_mask = 0b00000000_00000000_00000001_11111111
	center_of_mass_mode = CENTER_OF_MASS_MODE_CUSTOM


func on_block_enter(block: Block) -> void:
	mass += block.mass
	center_of_mass = _calculate_center_of_mass()


func on_block_exit(block: Block) -> void:
	mass -= block.mass
	center_of_mass = _calculate_center_of_mass()


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
	var offset := state.center_of_mass_local
	if not offset.is_zero_approx():
		for child in get_children():
			if child is Node3D:
				(child as Node3D).position -= offset
		state.transform = state.transform.translated_local(offset)
		center_of_mass -= offset
