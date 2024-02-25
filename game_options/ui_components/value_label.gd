extends Label
class_name GameOptionValueLabel

@export var key := ""
@export var section := ""


func _ready() -> void:
	var option := GameOptions.get_option(section, key)
	_refresh()
	option.value_changed.connect(func(): _refresh())


func _refresh() -> void:
	text = "%s %s" % [
		str(GameOptions.get_option(section, key).get_display_value()),
		GameOptions.get_option(section, key).get_display_suffix(),
	]
