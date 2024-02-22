extends Control


func _ready() -> void:
	Utils.grab_focus_first_visible_button(self)


func _on_quit_pressed() -> void:
	get_tree().quit()
