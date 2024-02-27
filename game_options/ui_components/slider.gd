extends Slider
class_name GameOptionSlider

var option: Option


func _ready() -> void:
	min_value = option.get_min_value()
	max_value = option.get_max_value()
	step = option.get_step()

	# After setting min_value, max_value as those could emit value_changed
	value_changed.connect(_on_value_changed)
	drag_ended.connect(_on_drag_ended)

	_refresh()
	option.value_changed.connect(func(): _refresh())


func _on_value_changed(_value: float) -> void:
	option.set_value(value)


func _on_drag_ended(_value_changed: bool):
	if _value_changed:
		GameOptions.save()


func _refresh() -> void:
	set_value_no_signal(option.get_value())
