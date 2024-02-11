extends Area3D


func _physics_process(_delta: float) -> void:
	gravity_direction = -global_basis.y
