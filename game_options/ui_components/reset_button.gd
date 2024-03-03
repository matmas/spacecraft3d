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
	visible = not _value_equals_initial_value()
	if had_focus and not visible:
		find_next_valid_focus().grab_focus()  # Maintain focus on something


func _on_pressed() -> void:
	if option.get_value() != option.initial_value:
		option.set_value(option.initial_value)
		GameOptions.save()


func _value_equals_initial_value() -> bool:
	var value = option.get_value()
	if value is Array and option.initial_value is Array:
		return var_to_str(value) == var_to_str(option.initial_value)
	return value == option.initial_value
