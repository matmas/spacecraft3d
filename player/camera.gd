extends Camera3D


func _ready() -> void:
	fov = GameOptions.get_option("graphics", "camera_fov").get_value()
