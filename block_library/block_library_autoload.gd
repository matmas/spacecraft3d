extends Node

var block_types: Array[BlockType] = []


func _ready() -> void:
	var scenes: Array[PackedScene]
	scenes = _get_block_scenes()
	for scene in scenes:
		var block_type := _get_property_value(scene.get_state(), &"block_type") as BlockType
		block_type.scene = scene
		block_types.append(block_type)


func _get_block_scenes() -> Array[PackedScene]:
	var result: Array[PackedScene] = []
	var dir_path := "res://block_library/blocks"
	var dir := DirAccess.open(dir_path)
	if not dir:
		printerr("Failed opening directory ", dir_path)
		return []
	dir.list_dir_begin()
	for file in dir.get_files():
		if file.ends_with(".tscn") or file.ends_with(".tscn.remap"):
			# Exported projects have .remap files instead
			var filename := file.trim_suffix(".remap")
			var path := dir.get_current_dir().path_join(filename)
			var scene := load(path) as PackedScene
			result.append(scene)
	dir.list_dir_end()
	return result


func _get_property_value(state: SceneState, property_name: StringName, node_idx: int = 0) -> Variant:
	for property_idx in state.get_node_property_count(node_idx):
		if state.get_node_property_name(node_idx, property_idx) == property_name:
			return state.get_node_property_value(node_idx, property_idx)
	return null
