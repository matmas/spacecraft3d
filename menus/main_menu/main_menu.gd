extends Control


func _ready() -> void:
	get_tree().quit_on_go_back = false
	Utils.grab_focus_first_visible_button(self)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _notification(what):
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST when visible:
			_on_quit_pressed()
