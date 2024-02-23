extends CheckButton
class_name GameOptionCheckButton

@export var key := ""
@export var section := ""


func _init() -> void:
	toggled.connect(_on_toggled)


func _on_toggled(toggled_on: bool) -> void:
	GameOptions.get_option(key, section).set_value(toggled_on)
	GameOptions.save()
	refresh()


func _ready() -> void:
	refresh()


func refresh() -> void:
	button_pressed = GameOptions.get_option(key, section).get_value()
