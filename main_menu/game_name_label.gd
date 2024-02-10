extends Label


func _ready() -> void:
	text = ProjectSettings.get(&"application/config/name")
