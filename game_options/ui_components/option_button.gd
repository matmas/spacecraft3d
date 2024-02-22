extends OptionButton
class_name GameOptionButton

@export var key := ""
@export var section := ""

var _is_populated := false


func _init() -> void:
	item_selected.connect(_on_item_selected)
	button_down.connect(_on_button_down)


func _ready() -> void:
	var current_value := GameOptions.get_handler(key, section).get_string_value()
	if current_value:
		add_item(current_value)
		select(0)
	else:
		# get_string_value() might not be implemented so populate everything
		_populate()
		_select_active()


func _on_button_down() -> void:
	if not _is_populated:
		_populate()
		_select_active()


func _populate() -> void:
	clear()
	for value in GameOptions.get_handler(key, section).get_possible_string_values():
		add_item(value)
	_is_populated = true


func _select_active() -> void:
	for index in item_count:
		var value := get_item_text(index)
		if GameOptions.get_handler(key, section).value_string_matches(value):
			select(index)


func _on_item_selected(index: int) -> void:
	var value := get_item_text(index)
	GameOptions.get_handler(key, section).set_value_string(value)
	GameOptions.save()
	_select_active()  # If something goes wrong we revert back to previous value


func refresh() -> void:
	_select_active()
