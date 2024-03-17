extends Scene
class_name BuildMenu

@onready var item_list: ItemList = $Body/ItemList


func _ready() -> void:
	item_list.clear()
	for piece in BuildLibrary.pieces:
		var scene_texture := SceneTexture.new()
		scene_texture.scene = piece
		var display_name := _get_property_value(piece.get_state(), &"display_name") as String
		item_list.add_item(display_name, scene_texture)
	super._ready()


func should_pause_game() -> bool:
	return false


func _get_property_value(state: SceneState, property_name: StringName, node_idx: int = 0) -> Variant:
	for property_idx in state.get_node_property_count(node_idx):
		if state.get_node_property_name(node_idx, property_idx) == property_name:
			return state.get_node_property_value(node_idx, property_idx)
	return null
