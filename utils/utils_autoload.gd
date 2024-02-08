extends Node


func grab_focus_first_button(node: Node) -> bool:
	if node is Button:
		(node as Button).grab_focus()
		return true
	for child in node.get_children():
		if grab_focus_first_button(child):
			return true
	return false


func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
