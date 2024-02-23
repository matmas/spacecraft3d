extends OptionButton
class_name GameOptionButton

@export var key := ""
@export var section := ""

var _is_populated := false


func _init() -> void:
	item_selected.connect(_on_item_selected)
	button_down.connect(_on_button_down)


func _ready() -> void:
	var current_value = GameOptions.get_option(section, key).get_string_value()
	if current_value:
		add_item(current_value)
		select(0)
	else:
		# get_string_value() is not implemented so populate everything
		_populate()
		_refresh()
	GameOptions.get_option(section, key).value_changed.connect(func(_value): _refresh())


func _on_button_down() -> void:
	if not _is_populated:
		_populate()
		_refresh()


func _populate() -> void:
	clear()
	for value in GameOptions.get_option(section, key).get_possible_string_values():
		add_item(value)
	_is_populated = true


func _on_item_selected(index: int) -> void:
	var value := get_item_text(index)
	GameOptions.get_option(section, key).set_value_string(value)
	GameOptions.save()


func _refresh() -> void:
	for index in item_count:
		var value := get_item_text(index)
		if GameOptions.get_option(section, key).value_string_matches(value):
			select(index)
