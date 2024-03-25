extends RigidBody3D
class_name Grid


func _init() -> void:
	name = "Grid"
	mass = 0.001
	collision_layer = 0b00000000_00000000_00000000_00000001
	collision_mask = 0b00000000_00000000_00000001_11111111
