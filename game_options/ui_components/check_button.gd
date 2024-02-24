extends CheckButton
class_name GameOptionCheckButton

@export var key := ""
@export var section := ""


func _init() -> void:
	toggled.connect(_on_toggled)


func _ready() -> void:
	_refresh()
	GameOptions.get_option(section, key).value_changed.connect(func(): _refresh())


func _on_toggled(toggled_on: bool) -> void:
	GameOptions.get_option(section, key).set_value(toggled_on)
	GameOptions.save()


func _refresh() -> void:
	set_pressed_no_signal(GameOptions.get_option(section, key).get_value())
