extends HBoxContainer
class_name InputmapEditorRow

var action: StringName
var action_description: String

@onready var label: Label = $Label
@onready var kbm_button := $KBMButton as RemapButton
@onready var controller_button := $ControllerButton as RemapButton

func _ready() -> void:
	label.text = action_description
	kbm_button.action = action
	controller_button.action = action


func refresh() -> void:
	kbm_button.refresh()
	controller_button.refresh()
