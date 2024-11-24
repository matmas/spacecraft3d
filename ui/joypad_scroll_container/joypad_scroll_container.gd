extends ScrollContainer
class_name JoypadScrollContainer

const SCROLL_SPEED = 750

var _scroll_accumulator := Vector2()


func _process(delta: float) -> void:
	_scroll_accumulator += Input.get_vector(
		&"ui_scroll_left", &"ui_scroll_right", &"ui_scroll_up", &"ui_scroll_down"
	) * SCROLL_SPEED * delta

	if absf(_scroll_accumulator.x) > 1:
		var scroll_int := int(_scroll_accumulator.x)
		scroll_horizontal += scroll_int
		_scroll_accumulator.x -= scroll_int
	if absf(_scroll_accumulator.y) > 1:
		var scroll_int := int(_scroll_accumulator.y)
		scroll_vertical += scroll_int
		_scroll_accumulator.y -= scroll_int
