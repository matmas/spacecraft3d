@tool
extends KeyIconRect
class_name InputIconRect

@export var input_event: InputEvent:
	set(value):
		input_event = value
		_update_text()


func _validate_property(property: Dictionary) -> void:
	if property.name == "text":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


#func _draw() -> void:
	#super._draw()


func _update_text() -> void:
	text = input_event.as_text()
	print(input_event)
	queue_redraw()
