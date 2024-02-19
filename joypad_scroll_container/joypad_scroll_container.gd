extends ScrollContainer
class_name JoypadScrollContainer

const SCROLL_SPEED = 750

var scroll_accumulator := Vector2()


func _process(delta: float) -> void:
	scroll_accumulator += Input.get_vector(
		&"ui_scroll_left", &"ui_scroll_right", &"ui_scroll_up", &"ui_scroll_down"
	) * SCROLL_SPEED * delta

	if absf(scroll_accumulator.x) > 1:
		var scroll_int := int(scroll_accumulator.x)
		scroll_horizontal += scroll_int
		scroll_accumulator.x -= scroll_int
	if absf(scroll_accumulator.y) > 1:
		var scroll_int := int(scroll_accumulator.y)
		scroll_vertical += scroll_int
		scroll_accumulator.y -= scroll_int
