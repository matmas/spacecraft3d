extends AnimatableBody3D

const SPEED = 5.0


func _process(delta: float) -> void:
	var velocity := Vector3.RIGHT * SPEED
	global_position += velocity * delta
	#move_and_collide(velocity * delta)
