extends Range
class_name GameOptionRange

@export var key := ""
@export var section := ""

func _init() -> void:
	value_changed.connect(_on_value_changed)


func _ready() -> void:
	var option := GameOptions.get_option(key, section)
	min_value = option.get_min_value()
	max_value = option.get_max_value()
	step = option.get_step()

	_refresh()
	option.value_changed.connect(func(_value): _refresh())


func _on_value_changed(_value: float) -> void:
	GameOptions.get_option(key, section).set_value(value)
	GameOptions.save()


func _refresh() -> void:
	value = GameOptions.get_option(key, section).get_value()
