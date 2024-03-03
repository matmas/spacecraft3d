extends Slider
class_name GameOptionSlider

var option: Option

var _is_dragging := false


func _ready() -> void:
	min_value = option.get_min_value()
	max_value = option.get_max_value()
	step = option.get_step()

	# Connect signals after setting min_value, max_value as those could emit value_changed
	value_changed.connect(_on_value_changed)
	drag_started.connect(_on_drag_started)
	drag_ended.connect(_on_drag_ended)

	_refresh()
	option.value_changed.connect(func(): _refresh())


func _on_value_changed(_value: float) -> void:
	option.set_value(value)
	if not _is_dragging:  # Using keyboard or controller
		GameOptions.save()


func _on_drag_started() -> void:
	_is_dragging = true


func _on_drag_ended(_value_changed: bool) -> void:
	_is_dragging = false
	if _value_changed:
		GameOptions.save()


func _refresh() -> void:
	set_value_no_signal(option.get_value())
