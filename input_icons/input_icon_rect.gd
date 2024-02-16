@tool
extends FallbackIconRect
class_name InputIconRect

@export var input_event: InputEvent

func _validate_property(property: Dictionary) -> void:
	if property.name == "text":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE
