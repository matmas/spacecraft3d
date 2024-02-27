extends WorldEnvironment


func _ready() -> void:
	environment.glow_enabled = GameOptions.get_bool_option("graphics", "glow").get_value()
