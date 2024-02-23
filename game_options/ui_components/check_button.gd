extends CheckButton
class_name GameOptionCheckButton

@export var key := ""
@export var section := ""


func _init() -> void:
	toggled.connect(_on_toggled)


func _ready() -> void:
	_refresh()
	GameOptions.get_option(key, section).value_changed.connect(func(_value): _refresh())


func _on_toggled(toggled_on: bool) -> void:
	GameOptions.get_option(key, section).set_value(toggled_on)
	GameOptions.save()


func _refresh() -> void:
	button_pressed = GameOptions.get_option(key, section).get_value()
