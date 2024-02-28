@tool
extends ShortcutButton


func _on_pressed() -> void:
	if owner and owner.get_parent():
		owner.get_parent().remove_child(owner)
		owner.queue_free()
