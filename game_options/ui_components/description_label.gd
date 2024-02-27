extends Label
class_name GameOptionDescriptionLabel

var option: Option


func _ready() -> void:
	_refresh()
	option.value_changed.connect(func(): _refresh())


func _refresh() -> void:
	text = option.get_description()
