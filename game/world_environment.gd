extends WorldEnvironment


func _ready() -> void:
	environment.glow_enabled = GameOptions.get_handler("display", "glow").current_value
