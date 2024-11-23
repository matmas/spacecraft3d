extends Scene
class_name BuildMenu

@onready var item_list: ItemList = %ItemList


func _ready() -> void:
	item_list.clear()
	for block_type in BlockLibrary.block_types:
		var index := item_list.add_item(block_type.display_name, block_type.scene_texture)

		if block_type == BuildingMechanics.selected_block_type:
			item_list.select(index)
	super._ready()


func _on_item_list_item_selected(index: int) -> void:
	BuildingMechanics.selected_block_type = BlockLibrary.block_types[index]
