extends Label
class_name GameOptionDescriptionAndValueLabel

@export var key := ""
@export var section := ""


func _ready() -> void:
	var option := GameOptions.get_option(section, key)
	_refresh()
	option.value_changed.connect(func(): _refresh())


func _refresh() -> void:
	var option := GameOptions.get_option(section, key)
	text = option.get_display_value()
	var description := option.get_description()
	if description:
		text += " (%s)" % description
