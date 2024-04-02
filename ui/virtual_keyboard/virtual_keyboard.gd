extends Scene
class_name VirtualKeyboard

@onready var left_shift := %LeftShift as Button
@onready var right_shift := %RightShift as Button
@onready var caps_lock := %CapsLock as Button
@onready var h := %H as Button

var line_edit: LineEdit
static var instance: VirtualKeyboard


func _ready() -> void:
	super._ready()
	instance = self
	h.grab_focus()


func should_focus_first_visible_button() -> bool:
	return false


func _on_left_pressed() -> void:
	line_edit.caret_column -= 1


func _on_right_pressed() -> void:
	line_edit.caret_column += 1


func _on_backspace_pressed() -> void:
	line_edit.delete_char_at_caret()


func _on_space_pressed() -> void:
	line_edit.insert_text_at_caret(" ")


func _on_shift_pressed() -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_SHIFT
	event.physical_keycode = KEY_SHIFT
	event.device = -1
	event.pressed = not Input.is_physical_key_pressed(KEY_SHIFT)
	Input.parse_input_event(event)


func _input(event: InputEvent) -> void:
	super._input(event)
	if event is InputEventKey:
		var e := event as InputEventKey
		if e.keycode == KEY_SHIFT:
			left_shift.button_pressed = e.pressed
			right_shift.button_pressed = e.pressed
		if e.keycode == KEY_CAPSLOCK:
			caps_lock.button_pressed = e.pressed


func _on_caps_lock_toggled(toggled_on: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_CAPSLOCK
	event.physical_keycode = KEY_CAPSLOCK
	event.device = -1
	event.pressed = toggled_on
	Input.parse_input_event(event)
