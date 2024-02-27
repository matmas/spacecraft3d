extends HBoxContainer
class_name InputmapEditorRow

var action: StringName
var action_description: String

@onready var action_label: Label = $ActionLabel
@onready var kbm_button := $KBMButton
@onready var controller_button := $ControllerButton


func _ready() -> void:
	action_label.text = action_description
	kbm_button.action = action
	controller_button.action = action


func refresh() -> void:
	kbm_button.refresh()
	controller_button.refresh()
