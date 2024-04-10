extends RigidBody3D
class_name Grid


func _init() -> void:
	name = "Grid"
	mass = 0.001
	collision_layer = 0b00000000_00000000_00000000_00000001
	collision_mask = 0b00000000_00000000_00000001_11111111


func on_block_enter(block: Block) -> void:
	mass += block.mass


func on_block_exit(block: Block) -> void:
	mass -= block.mass


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var offset := state.center_of_mass_local
	if not offset.is_zero_approx():
		for child in get_children():
			if child is Node3D:
				(child as Node3D).position -= offset
		state.transform = state.transform.translated_local(offset)
