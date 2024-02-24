extends Slider
class_name GameOptionSlider

@export var key := ""
@export var section := ""


func _ready() -> void:
	var option := GameOptions.get_option(section, key)
	min_value = option.get_min_display_value()
	max_value = option.get_max_display_value()
	step = option.get_display_step()

	# After setting min_value, max_value as those could emit value_changed
	value_changed.connect(_on_value_changed)
	drag_ended.connect(_on_drag_ended)

	_refresh()
	option.value_changed.connect(func(): _refresh())


func _on_value_changed(_value: float) -> void:
	GameOptions.get_option(section, key).set_display_value(value)


func _on_drag_ended(_value_changed: bool):
	if _value_changed:
		GameOptions.save()


func _refresh() -> void:
	set_value_no_signal(GameOptions.get_option(section, key).get_display_value())
