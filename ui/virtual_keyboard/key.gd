extends Button

@export var shift_label: String
@export var affected_by_caps_lock: bool

var _original_text: String
var _shift_state := false
var _caps_lock_state := false


func _init() -> void:
	_original_text = text
	button_down.connect(_on_button_down)


func _on_button_down() -> void:
	VirtualKeyboard.instance.line_edit.insert_text_at_caret(text)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var e := event as InputEventKey

		match e.keycode:
			KEY_SHIFT:
				_shift_state = e.pressed
				_update_text()
			KEY_CAPSLOCK:
				_caps_lock_state = e.pressed
				_update_text()


func _update_text() -> void:
	if (not affected_by_caps_lock and _shift_state or
			affected_by_caps_lock and (_shift_state and not _caps_lock_state or not _shift_state and _caps_lock_state)):
		text = shift_label
	else:
		text = _original_text
