extends VBoxContainer


func _on_reset_pressed() -> void:
	GameOptions.reset_to_defaults()
	_refresh_recursively(self)


func _refresh_recursively(node: Node) -> void:
	if node is GameOptionButton:
		(node as GameOptionButton).refresh()
	if node is GameOptionCheckButton:
		(node as GameOptionCheckButton).refresh()

	for child in node.get_children():
		_refresh_recursively(child)
