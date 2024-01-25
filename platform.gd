extends AnimatableBody3D

const SPEED = 5.0


func _physics_process(delta: float) -> void:
	var velocity := Vector3.RIGHT * SPEED
	move_and_collide(velocity * delta)
