extends VBoxContainer


func _ready() -> void:
	Utils.grab_focus_first_visible_button(self)
