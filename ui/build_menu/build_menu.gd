extends Scene
class_name BuildMenu

@onready var item_list: ItemList = %ItemList


func _ready() -> void:
	item_list.clear()
	for block in BlockLibrary.blocks:
		var scene_texture := SceneTexture.new()
		scene_texture.scene = block
		var display_name := _get_property_value(block.get_state(), &"display_name") as String
		var index := item_list.add_item(display_name, scene_texture)

		if block == BuildingMechanics.selected_block:
			item_list.select(index)
	super._ready()


func should_pause_game() -> bool:
	return false


func _get_property_value(state: SceneState, property_name: StringName, node_idx: int = 0) -> Variant:
	for property_idx in state.get_node_property_count(node_idx):
		if state.get_node_property_name(node_idx, property_idx) == property_name:
			return state.get_node_property_value(node_idx, property_idx)
	return null


func _on_item_list_item_selected(index: int) -> void:
	BuildingMechanics.selected_block = BlockLibrary.blocks[index]
