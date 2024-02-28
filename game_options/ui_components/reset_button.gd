extends Button
class_name GameOptionResetButton

var option: Option


func _ready() -> void:
	icon = preload("../icons/Reload.svg")
	flat = true
	pressed.connect(_on_pressed)
	_refresh()
	option.value_changed.connect(_refresh)


func _refresh() -> void:
	var had_focus := has_focus()
	visible = option.get_value() != option.initial_value
	if had_focus and not visible:
		find_next_valid_focus().grab_focus()  # Maintain focus on something


func _on_pressed() -> void:
	if option.get_value() != option.initial_value:
		option.set_value(option.initial_value)
		GameOptions.save()
