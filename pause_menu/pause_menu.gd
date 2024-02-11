extends Control

func _ready():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause_menu"):
		get_tree().paused = true
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Utils.grab_focus_first_button(self)


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
