extends Button


func _ready() -> void:
	if OS.get_name() in ["Web"]:
		hide()
		return

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	get_tree().quit()
