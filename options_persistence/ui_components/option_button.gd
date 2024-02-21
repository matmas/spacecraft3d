extends OptionButton

@export var key := ""
@export var section := ""

func _init() -> void:
	item_selected.connect(_on_item_selected)


func _ready() -> void:
	_select_active()


func _select_active() -> void:
	for index in item_count:
		var value := get_item_text(index)
		if OptionsPersistence.get_handler(key, section).value_string_matches(value):
			select(index)


func _on_item_selected(index: int) -> void:
	var value := get_item_text(index)
	OptionsPersistence.get_handler(key, section).set_value_string(value)
	OptionsPersistence.save()
	_select_active()  # If something goes wrong we revert back to previous value
