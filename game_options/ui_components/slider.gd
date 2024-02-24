extends Slider
class_name GameOptionSlider

@export var key := ""
@export var section := ""


func _init() -> void:
	value_changed.connect(_on_value_changed)
	drag_ended.connect(_on_drag_ended)


func _ready() -> void:
	var option := GameOptions.get_option(section, key)
	min_value = option.get_min_value()
	max_value = option.get_max_value()
	step = option.get_step()

	_refresh()
	option.value_changed.connect(func(_value): _refresh())


func _on_value_changed(_value: float) -> void:
	GameOptions.get_option(section, key).set_value(value)


func _on_drag_ended(_value_changed: bool):
	if _value_changed:
		GameOptions.save()


func _refresh() -> void:
	set_value_no_signal(GameOptions.get_option(section, key).get_value())
