extends Camera3D


func _ready() -> void:
	fov = GameOptions.get_handler("display", "camera_fov").current_value
