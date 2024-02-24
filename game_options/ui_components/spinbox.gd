extends SpinBox
class_name GameOptionSpinBox

@export var key := ""
@export var section := ""


func _init() -> void:
	value_changed.connect(_on_value_changed)


func _ready() -> void:
	var option := GameOptions.get_option(section, key)
	set_value_no_signal(option.get_min_value())  # Prevents emitting value_changed signal when changing min_value
	min_value = option.get_min_value()
	max_value = option.get_max_value()
	step = option.get_step()

	_refresh()
	option.value_changed.connect(func(_value): _refresh())


func _on_value_changed(_value: float) -> void:
	GameOptions.get_option(section, key).set_value(value)
	GameOptions.save()


func _refresh() -> void:
	set_value_no_signal(GameOptions.get_option(section, key).get_value())
