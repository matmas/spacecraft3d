extends Label
class_name GameOptionDescriptionAndValueLabel

var option: Option


func _ready() -> void:
	_refresh()
	option.value_changed.connect(func(): _refresh())


func _refresh() -> void:
	text = option.get_display_value()
	var description := option.get_description()
	if description:
		text += " (%s)" % description
