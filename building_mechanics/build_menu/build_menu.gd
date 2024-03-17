extends Scene
class_name BuildMenu

@onready var item_list: ItemList = $Body/ItemList


func _ready() -> void:
	item_list.clear()
	for scene in BuildLibrary.pieces:
		var scene_texture := SceneTexture.new()
		scene_texture.scene = scene
		item_list.add_item("test", scene_texture)
	super._ready()


func should_pause_game() -> bool:
	return false
