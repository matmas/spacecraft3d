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
	text = "%s %s" % [
		str(option.get_display_value()),
		option.get_display_suffix(),
	]
	var description := option.get_description()
	if description:
		text += " (%s)" % description
