extends CheckButton
class_name GameOptionCheckButton

var option: Option


func _init() -> void:
	toggled.connect(_on_toggled)


func _ready() -> void:
	_refresh()
	option.value_changed.connect(func(): _refresh())


func _on_toggled(toggled_on: bool) -> void:
	option.set_value(toggled_on)
	GameOptions.save()


func _refresh() -> void:
	set_pressed_no_signal(option.get_value())
