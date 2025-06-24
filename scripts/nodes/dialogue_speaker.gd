class_name DialogueSpeaker
extends Node2D

const SPEAKER_GROUP: StringName = &"DialogueSpeakers"

@export var character: DialogicCharacter


func _ready() -> void:
	add_to_group(SPEAKER_GROUP)
	var layout_node: Node
	if not Dialogic.Styles.has_active_layout_node():
		layout_node = Dialogic.Styles.load_style()
	else:
		layout_node = Dialogic.Styles.get_layout_node()
	layout_node.register_character(character, self)
