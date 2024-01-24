extends Camera3D

@onready var platform := $"../Platform"


func _process(_delta: float) -> void:
	global_position = platform.global_position + Vector3(-8, 3, 0)
