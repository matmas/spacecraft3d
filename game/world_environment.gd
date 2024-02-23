extends WorldEnvironment


func _ready() -> void:
	environment.glow_enabled = GameOptions.get_option("display", "glow").get_value()
