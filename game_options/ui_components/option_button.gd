extends OptionButton

@export var key := ""
@export var section := ""


func _init() -> void:
	item_selected.connect(_on_item_selected)


func _ready() -> void:
	for value in GameOptions.get_handler(key, section).get_possible_string_values():
		add_item(value)
	_select_active()


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
